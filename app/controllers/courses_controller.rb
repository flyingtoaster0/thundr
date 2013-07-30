class CoursesController < ApplicationController


  def new
  end

  def create
    @course = Course.new(params[:course])

    @course.save
    redirect_to @course
  end

  def show
    @course = Course.find(params[:id])
  end

  def index
    @test = current_user
    @courses = Course.all
  end


end
