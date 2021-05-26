require 'rails_helper'
# Test for single user access only, index not authorized for users
RSpec.describe "Users Favorites", type: :request do
    describe "Single User request" do
        before(:each) do 
            @user = User.create(name: 'tester', email: 'test@test.com', password: 'password', password_confirmation: 'password')
            @auth = {'Authorization': "Bearer #{JsonWebToken.encode(user_id: @user.id)}"}
        end
        context "New Favorite" do
            it "succesfully creates new user favorite with required attributes" do
                payload = {
                    name: 'name',
                    fmid: 4760253,
                    address: 'addy',
                    dates: 'datestring',
                    times: 'timestring'
                }
                post "/api/v1/users/#{@user.id}/favorites/new", headers: @auth, params: payload
                expect(response).to have_http_status(:success)
                resp = JSON.parse(response.body, :symbolize_names => true)
                expect(resp[:data]).to have_key(:id)
                expect(resp[:data][:type]).to eql('user')
                expect(resp[:data]).to have_key(:attributes)
                expect(resp[:data][:attributes][:id]).to eql(@user.id)
                expect(resp[:data][:attributes][:name]).to eql(@user.name)
                expect(resp[:data][:attributes][:email]).to eql(@user.email)
                expect(resp[:data][:attributes]).to have_key(:favorites)
                expect(resp[:data][:attributes][:favorites].first).to have_key(:id)
                expect(resp[:data][:attributes][:favorites].first[:name]).to eql(payload[:name])
                expect(resp[:data][:attributes][:favorites].first[:fmid]).to eql(payload[:fmid])
                expect(resp[:data][:attributes][:favorites].first[:address]).to eql(payload[:address])
                expect(resp[:data][:attributes][:favorites].first[:dates]).to eql(payload[:dates])
                expect(resp[:data][:attributes][:favorites].first[:times]).to eql(payload[:times])
            end
        end

        context "Existing Favorites" do
            it "can remove a single user favorite" do
                favorite = @user.favorites.create!(
                    name: 'name',
                    fmid: 4760253,
                    address: 'addy',
                    dates: 'datestring',
                    times: 'timestring')
                expect(@user.favorites.length).to eql(1)

                delete "/api/v1/users/#{@user.id}/favorites/#{favorite.id}", headers: @auth
                resp = JSON.parse(response.body, symbolize_names: true)

                expect(resp[:data]).to have_key(:id)
                expect(resp[:data][:type]).to eql('user')
                expect(resp[:data]).to have_key(:attributes)
                expect(resp[:data][:attributes][:id]).to eql(@user.id)
                expect(resp[:data][:attributes][:name]).to eql(@user.name)
                expect(resp[:data][:attributes][:email]).to eql(@user.email)
                expect(resp[:data][:attributes]).to have_key(:favorites)
                expect(resp[:data][:attributes][:favorites]).to be_a(Array)
                expect(resp[:data][:attributes][:favorites].length).to eql(0)
            end
        end
    end
end