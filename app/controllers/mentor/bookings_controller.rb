class Mentor::BookingsController < ApplicationController
  def index
    @mentor = Mentor.where(user: current_user).first
    @bookings = Booking.where(mentor: @mentor)
  end
end
