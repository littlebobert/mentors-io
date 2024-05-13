class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :mentor

  validates :start_time, presence: true, uniqueness: { scope: :mentor }
end
