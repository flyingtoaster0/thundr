class DepartmentsController < ApplicationController
  def new
  end

  def create
    #@course = Course.new(params[:course])
  end

  def show
    @department = Department.find_by_deptCode(params[:id])
  end

  def index
  end

end
