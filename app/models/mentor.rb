class Mentor < ApplicationRecord
  has_one_attached :photo
  SPECIALTIES = ["medicine", "tech", "business", "astrology", "sports", "dating", "style", "wellness"]

  belongs_to :user
  has_many :bookings, dependent: :destroy
  validates :user, presence: true, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search_by_name_and_bio_and_tagline,
  against: [ :tagline, :bio ],
  associated_against: {
    user: [ :name ]
  },
  using: {
    tsearch: { prefix: true } # <-- now `superman batm` will return something!
  }
end
