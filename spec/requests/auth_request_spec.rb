require 'rails_helper'
# Test for single user access only, index not authorized for users
RSpec.describe "User Auth", type: :request do
    describe "Single User Login" do
        it "is successful with proper parameters" do
            user = User.create!(name: 'Test', email: 'test@test.com', password: 'password')
            payload = {email: 'test@test.com', password: 'password'}
            post '/api/v1/auth/login', params: payload
            expect(response).to have_http_status(:success)
            resp = JSON.parse(response.body, symbolize_names: true)
            expect(resp).to have_key(:token)
            expect(resp).to have_key(:exp)
            expect(resp).to have_key(:user)
            expect(resp[:user]).to eql(user.id)
            expect(resp[:token]).to be_a(String)
        end

        it "returns an error with incorrect credentials" do
            user = User.create!(name: 'Test', email: 'test@test.com', password: 'password')
            payload = {email: 'test@test.com', password: 'passwordddd'}
            post '/api/v1/auth/login', params: payload
            expect(response).to have_http_status(:unauthorized)
            resp = JSON.parse(response.body, symbolize_names: true)
            expect(resp[:errors]).to eql('Unauthorized')
        end
    end

    describe "User has logged in, received token" do
        before(:each) do
            @user = User.create!(name: 'Test', email: 'test@test.com', password: 'password')
            payload = {email: 'test@test.com', password: 'password'}
            post '/api/v1/auth/login', params: payload
            @resp_init = JSON.parse(response.body, symbolize_names: true)
        end

        it "return success with proper auth headers and token" do
            auth = {'Authorization': "Bearer #{@resp_init[:token]}"}
            get "/api/v1/users/#{@user.id}", headers: auth
            expect(response).to have_http_status(:success)
            resp = JSON.parse(response.body, symbolize_names: true)
            expect(resp[:data][:id]).to eql(@user.id.to_s)
            expect(resp[:data][:type]).to eql('user')
            expect(resp[:data][:attributes][:id]).to eql(@user.id)
            expect(resp[:data][:attributes][:name]).to eql(@user.name)
            expect(resp[:data][:attributes][:email]).to eql(@user.email)
        end

        it "returns an error without auth token" do
            get "/api/v1/users/#{@user.id}"
            expect(response).to have_http_status(:unauthorized)
            resp = JSON.parse(response.body, symbolize_names: true)
            expect(resp[:error]).to eql("Nil JSON web token")
        end

        it "returns an error with missing users token" do
            temp_user = User.create(name: 'tester', email: 'temp@temp.com', password: 'password', password_confirmation: 'password')
            jwt = JsonWebToken.encode(user_id: temp_user.id)
            temp_user.destroy!
            token = {'Authorization': "Bearer #{jwt}"}
            get "/api/v1/users/#{@user.id}", headers: token
            expect(response).to have_http_status(:unauthorized)
            resp = JSON.parse(response.body, symbolize_names: true)
            expect(resp[:error]).to eql("Couldn't find User with 'id'=#{temp_user.id}") # ID is depicted in middle segment of token ^
        end

        it "returns an error with incomplete token" do
            # Token is same as above but removed handful of characters
            token = {'Authorization': 'Bearer eyJhbGciOiJIUzI1NJ9.eyJ1c2VyX2lkIjo1NDcsImV4cCI6MTyMTk5NjMwNn0.yAxEVdITH50WcuOl0jxAUc4gJztdFB07zc10RJHED0'}
            get "/api/v1/users/#{@user.id}", headers: token
            expect(response).to have_http_status(:unauthorized)
            resp = JSON.parse(response.body, symbolize_names: true)
            expect(resp[:error]).to eql("Invalid segment encoding")
        end
    end
end