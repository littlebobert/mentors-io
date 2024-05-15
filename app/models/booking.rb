class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :mentor

  validates :start_time, presence: true, uniqueness: { scope: :mentor }
  validates :status, presence: true

  STATUSES = ["pending", "upcoming", "completed", "canceled"]
end
