class BookingsController < ApplicationController
  def create
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

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path
  end

  private

  def strong_params
    params.require(:booking).permit(:start_time).merge(user: current_user, mentor: @mentor, status: "pending")
  end
end
