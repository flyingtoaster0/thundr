class API::CoursesController < ApplicationController
  def index
    @courses = Course.all
    respond_to do |format|
      format.json { render :json => @courses }
    end
  end

  def show
    @course = Course.where('code = ? AND department = ?', params[:course_id], params[:department_id]).first
    respond_to do |format|
      format.json { render :json => @course }
    end
  end

  def find_by_department
    @courses = Course.where('department = ?', params[:department_id])
    respond_to do |format|
      format.json { render :json => @courses }
    end
  end
end