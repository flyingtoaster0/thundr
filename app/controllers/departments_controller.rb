class DepartmentsController < ApplicationController
  def new
  end

  def create
    #@course = Course.new(params[:course])
  end

  def show
    @department = Department.find_by_deptCode(params[:id])

    @courses = Course.find_all_by_department(params[:id], :conditions => ['method != ? and method!= ?', 'LAB', 'TUT'], :order => 'code ASC').uniq_by{|x| x.code}

  end

  def index
  end

end
