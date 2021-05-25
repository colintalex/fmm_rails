require 'rails_helper'

RSpec.describe User, type: :model do
  context "Validations" do
    it "is created with required attributes" do
      user = User.create!(name: 'Tester', email: 'test@test.com')
      expect(user).to be_valid
      expect(user.name).to eql('Tester')
      expect(user.email).to eql('test@test.com')
      expect(User.all.length).to eql(1)
      user.destroy
    end

    it "is invalid without email" do
      user = User.create(name: 'Tester')
      expect(user).to_not be_valid
      expect(User.all.length).to eql(0)
    end

    it "is invalid without name" do
      user = User.create(email: 'tester@test.com')
      expect(user).to_not be_valid
      expect(User.all.length).to eql(0)
    end

    it "is invalid without name and email" do
      user = User.create()
      expect(user).to_not be_valid
      expect(User.all.length).to eql(0)
    end

    context "Email" do
      xit "checks email for proper format" do

      end
    end
  end
end
