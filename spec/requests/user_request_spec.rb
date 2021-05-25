require 'rails_helper'
# Test for single user access only, index not authorized for users
RSpec.describe "Users", type: :request do
  describe "GET /" do
    it "returns http success" do
      user = User.create!(name: 'Tester', email: 'test@test.com')
      get "/user/#{user.id}"
      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body, :symbolize_names => true)
      expect(data.user.id).to eql(user.id)
      expect(data.user.name).to eql(user.name)
      expect(data.user.email).to eql(user.email)
    end
  end

end
