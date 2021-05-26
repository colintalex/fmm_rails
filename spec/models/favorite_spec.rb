require 'rails_helper'

RSpec.describe Favorite, type: :model do
    before(:each) do
        @user.destroy if @user
        @user = User.create!(name: 'Tester', email: 'test@test.com', password: 'password')
    end
    context "Validations" do
        it "is created with required attributes" do
            favorite = @user.favorites.create!(
                name: 'name',
                fmid: 4760253,
                address: 'addy',
                dates: 'datestring',
                times: 'timestring')
            
                expect(favorite).to be_valid
                expect(@user.favorites.length).to eql(1)
                expect(@user.favorites[0]).to eql(favorite)
        end

        it "errors without name" do
            expect{ @user.favorites.create!(
                fmid: 4760253,
                address: 'addy',
                dates: 'datestring',
                times: 'timestring')}.to raise_error(ActiveRecord::RecordInvalid)
                expect(@user.favorites.length).to eql(0)                
        end

        it "errors without fmid" do
            expect{ @user.favorites.create!(
                name: 'name',
                address: 'addy',
                dates: 'datestring',
                times: 'timestring')}.to raise_error(ActiveRecord::RecordInvalid)
                expect(@user.favorites.length).to eql(0)  
        end

        it "errors without address" do
            expect{ @user.favorites.create!(
                name: 'name',
                fmid: 4760253,
                dates: 'datestring',
                times: 'timestring')}.to raise_error(ActiveRecord::RecordInvalid)
                expect(@user.favorites.length).to eql(0)  
        end

        it "errors without dates" do
            expect{ @user.favorites.create!(
                name: 'name',
                fmid: 4760253,
                address: 'addy',
                times: 'timestring')}.to raise_error(ActiveRecord::RecordInvalid)
                expect(@user.favorites.length).to eql(0)  
        end

        it "returns success without times, optional" do
            favorite = @user.favorites.create!(
                name: 'name',
                fmid: 4760253,
                address: 'addy',
                dates: 'datestring')        
                expect(favorite).to be_valid
                expect(@user.favorites.length).to eql(1)
        end
    end
end