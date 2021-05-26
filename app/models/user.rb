class User < ApplicationRecord
    validates :name, presence: true
    validates :email, uniqueness: true, presence: true
    has_secure_password
    has_many :favorites
end
