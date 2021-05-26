class User < ApplicationRecord
    validates :name, length: { minimum: 1 }, presence: true
    validates :email, uniqueness: true, presence: true
    validates :default_location, presence: false
    has_secure_password
    has_many :favorites
end
