class Mentor < ApplicationRecord
  SPECIALTIES = ["medicine", "tech", "business", "astrology", "fashion"]

  belongs_to :user
  has_many :bookings, dependent: :destroy
  validates :user, presence: true, uniqueness: true
end
