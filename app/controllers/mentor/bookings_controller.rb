class Mentor::BookingsController < ApplicationController
  def index
    @bookings = Booking.all
    @mentor = current_user.mentor
    raise
  end
end
