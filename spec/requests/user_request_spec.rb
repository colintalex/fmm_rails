require 'rails_helper'
# Test for single user access only, index not authorized for users
RSpec.describe "Users", type: :request do
  describe "Single User request" do
    context "New User" do
      it "succesfully creates new user with required attributes" do
        payload = {name: 'tester', email: 'test@test.com'}
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

      it "returns an error with missing name" do
        payload = {email: 'test@test.com'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Name can't be blank"])
        expect(resp).to_not have_key(:data)
      end

      it "returns an error with missing email" do
        payload = {name: 'tester'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Email can't be blank"])
        expect(resp).to_not have_key(:data)
      end

      it "returns an error with missing email and name" do
        payload = {}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Name can't be blank", "Email can't be blank"])
        expect(resp).to_not have_key(:data)
      end

      it "returns an error for duplicate email" do
        user = User.create!(name: 'Testeroni', email: 'test@test.com')
        payload = {name: 'tester', email: 'test@test.com'}
        post "/api/v1/users/new", params: payload
        expect(response).to have_http_status(400)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Email has already been taken"])
        expect(resp).to_not have_key(:data)
      end
    end

    context "Existing User" do
      it "successfully returns a single user" do
        user = User.create!(name: 'Tester', email: 'test@test.com')
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(:success)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:data][:id]).to eql(user.id.to_s)
        expect(resp[:data][:type]).to eql('user')
        expect(resp[:data][:attributes][:id]).to eql(user.id)
        expect(resp[:data][:attributes][:name]).to eql(user.name)
        expect(resp[:data][:attributes][:email]).to eql(user.email)
        user.destroy
      end

      it "returns an error for invalid user id" do
        user = User.create!(name: 'Tester', email: 'test@test.com')
        get "/api/v1/users/451231234123"
        expect(response).to have_http_status(:bad_request)
        resp = JSON.parse(response.body, :symbolize_names => true)
        expect(resp[:status]).to eql('error')
        expect(resp[:messages]).to eql(["Invalid User ID"])
        expect(resp).to_not have_key(:data)
        user.destroy
      end
    end
  end
end
