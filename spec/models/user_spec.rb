require 'rails_helper'

RSpec.describe User, type: :model do
  context "Required attributes" do
    it "is created with required attributes" do
      user = User.create!(name: 'Tester', email: 'test@test.com')
      expect(user).to be_valid
      expect(User.all.length).to eql(1)
    end
  end
end
