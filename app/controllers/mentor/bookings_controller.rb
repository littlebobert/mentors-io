class Mentor::BookingsController < ApplicationController
  def index
    @mentor = Mentor.where(user: current_user).first
    @bookings = Booking.where(mentor: @mentor)
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.update(status: params["status"])
    if @booking.save
      redirect_to mentor_mentor_bookings_path(:status => "pending")
    else
      render "bookings/index", status: :unprocessable_entity
    end
  end
end
