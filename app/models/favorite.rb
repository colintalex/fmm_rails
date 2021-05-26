class Favorite < ApplicationRecord
    validates :name, presence: true
    validates :fmid, presence: true
    validates :address, presence: true
    validates :dates, presence: true
    validates :times, presence: false
    belongs_to :user
end
