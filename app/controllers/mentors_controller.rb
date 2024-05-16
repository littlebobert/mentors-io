class MentorsController < ApplicationController
  def index
    @mentors = Mentor.all
    if params[:query].present?
      @mentors = Mentor.joins(:user)
        .where("name ILIKE ?", "%#{params[:query]}%")
    else
      @mentors = Mentor.all
    end
  end

  def show
    @mentor = Mentor.find(params[:id])
    @booking = Booking.new
  end
end
