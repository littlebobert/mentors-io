class MentorsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    if params[:query].present?
      @mentors = Mentor.search_by_name_and_bio_and_tagline(params[:query])
    else
      @mentors = Mentor.all
    end
  end

  def show
    @mentor = Mentor.find(params[:id])
    @booking = Booking.new
  end

  def new
    @mentor = Mentor.new
  end

  def create
    @mentor = Mentor.new(mentor_params)
    @mentor.user = current_user

    if @mentor.save
      redirect_to @mentor, notice: "Welcome to mentors.io!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def mentor_params
    params.require(:mentor).permit(:specialty, :photo, :price, :tagline, :bio)
  end
end
