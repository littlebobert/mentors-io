class BookingsController < ApplicationController
  def create
    unless user_signed_in?
      redirect_to new_user_session_path
      return
    end
    @mentor = Mentor.find(params[:mentor_id])
    @booking = Booking.new(strong_params)
    if @booking.save
      redirect_to bookings_path
    else
      render 'mentors/show', status: :unprocessable_entity
    end
  end

  def index
    @bookings = Booking.where(user: current_user)
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.update(status: params["status"])
    if @booking.save
      redirect_to bookings_path
    else
      render "bookings/index", status: :unprocessable_entity
    end
  end

  private

  def strong_params
    params.require(:booking).permit(:start_time).merge(user: current_user, mentor: @mentor, status: "pending")
  end
end
