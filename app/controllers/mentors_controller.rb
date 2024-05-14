class MentorsController < ApplicationController
  def index
    @mentors = Mentor.all
  end

  def show
    @mentor = Mentor.find(params[:id])
  end
end
