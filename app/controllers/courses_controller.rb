class CoursesController < ApplicationController
  def new
  end

  def create
    render text: params[:course].inspect
  end
end
