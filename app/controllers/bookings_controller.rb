class BookingsController < ApplicationController
  def create
    @mentor = Mentor.find(params[:mentor_id])
    @booking = Booking.new(strong_params)
    if @booking.save
      redirect_to mentor_path(@mentor)
    else
      render 'mentors/show', status: :unprocessable_entity
    end
  end

  private

  def strong_params
    params.require(:booking).permit(:start_time).merge(user: current_user, mentor: @mentor)
  end
end
