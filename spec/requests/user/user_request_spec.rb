require 'rails_helper'
# Test for single user access only, index not authorized for users
RSpec.describe "Users", type: :request do
  describe "Single User request" do
    context "New User" do
      it "succesfully creates new user with required attributes" do
        payload = {name: 'tester', email: 'test@test.com', password: 'password', password_confirmation: 'password'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(:success)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:data]).to have_key(:id)
        expect(resp[:data][:type]).to eql('user')
        expect(resp[:data]).to have_key(:attributes)
        expect(resp[:data][:attributes]).to have_key(:id)
        expect(resp[:data][:attributes][:name]).to eql(payload[:name])
        expect(resp[:data][:attributes][:email]).to eql(payload[:email])
      end

      it "returns an error with bad password confirmtion" do
        payload = {name: 'tester', email: 'test@test.com', password: 'password', password_confirmation: 'passworddd'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(:conflict)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:errors]).to eql("Passwords Don't Match")
      end

      it "returns an error with missing name" do
        payload = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Name is too short (minimum is 1 character)", "Name can't be blank"])
        expect(resp).to_not have_key(:data)
      end

      it "returns an error with missing email" do
        payload = {name: 'tester', password: 'password', password_confirmation: 'password'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Email can't be blank"])
        expect(resp).to_not have_key(:data)
      end

      it "returns an error with missing email and name" do
        payload = {password: 'password', password_confirmation: 'password'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Name is too short (minimum is 1 character)", "Name can't be blank", "Email can't be blank"])
        expect(resp).to_not have_key(:data)
      end

      it "returns an error for duplicate email" do
        user = User.create!(name: 'Testeroni', email: 'test@test.com', password: 'password')
        payload = {name: 'tester', email: 'test@test.com'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Email has already been taken", "Password can't be blank"])
        expect(resp).to_not have_key(:data)
      end
    end

    context "Existing User" do
      before(:each) do
            @user = User.create!(name: 'Test', email: 'test@test.com', password: 'password')
            @auth = {'Authorization': "Bearer #{JsonWebToken.encode(user_id: @user.id)}"}
      end

      it "successfully returns a single user" do
        get "/api/v1/users/#{@user.id}", headers: @auth
        expect(response).to have_http_status(:success)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:data][:id]).to eql(@user.id.to_s)
        expect(resp[:data][:type]).to eql('user')
        expect(resp[:data][:attributes][:id]).to eql(@user.id)
        expect(resp[:data][:attributes][:name]).to eql(@user.name)
        expect(resp[:data][:attributes][:email]).to eql(@user.email)
      end

      it "successfully updates a user and responds with updated user" do
        payload = {
          name: 'NewName'
        }
        put "/api/v1/users/#{@user.id}", headers: @auth, params: payload
        expect(response).to have_http_status(:success)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:data][:id]).to eql(@user.id.to_s)
        expect(resp[:data][:type]).to eql('user')
        expect(resp[:data][:attributes][:id]).to eql(@user.id)
        expect(resp[:data][:attributes][:name]).to eql(payload[:name])
        expect(resp[:data][:attributes][:email]).to eql(@user.email)
      end

      it "returns an error updating with incorrect validations" do
        payload = {
          name: ''
        }
        put "/api/v1/users/#{@user.id}", headers: @auth, params: payload
        expect(response).to have_http_status(:not_acceptable)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp).to_not have_key(:data)
        expect(resp).to have_key(:error)
        expect(resp[:error]).to eql("Validation failed: Name is too short (minimum is 1 character), Name can't be blank")
      end
      
    end
    
    describe "Deleting User" do
      before(:each) do
            @user = User.create!(name: 'Test', email: 'test@test.com', password: 'password')
            @auth = {'Authorization': "Bearer #{JsonWebToken.encode(user_id: @user.id)}"}
      end
      it "can successfully delete an authorized user" do
        delete "/api/v1/users/#{@user.id}", headers: @auth
        expect(response).to have_http_status(:accepted)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:message]).to eql('User successfully deleted')
      end
    end
  end
end
