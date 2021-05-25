require 'rails_helper'
# Test for single user access only, index not authorized for users
RSpec.describe "Users", type: :request do
  describe "GET /" do
    it "returns http success" do
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
  end

end
