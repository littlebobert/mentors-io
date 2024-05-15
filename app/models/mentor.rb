class Mentor < ApplicationRecord
  has_one_attached :photo
  SPECIALTIES = ["medicine", "tech", "business", "astrology", "sports", "dating", "style", "wellness"]

  belongs_to :user
  has_many :bookings, dependent: :destroy
  validates :user, presence: true, uniqueness: true
end
