class DepartmentsController < ApplicationController
  def new
  end

  def create
    #@course = Course.new(params[:course])
  end

  def show
    @department = Department.find_by_deptCode(params[:id])


    @courses = Course.where('department = ? AND method != ? AND method!= ?', params[:id], 'LAB', 'TUT').order('course_code ASC')

    @sections = Array.new

    @courses.each do |c|
      Section.where(:department => c.department, :course_code => c.course_code).each do |s|
        @sections.append(s)
      end
    end

    # See if there's a neater way to do the above with where(). I mean, preferably without getting into scoping, but if it comes to that...
    #@courses = Course.where(:department => params[:id], :conditions => ['method != ? and method!= ?', 'LAB', 'TUT']).order('course_code ASC')
  end

  def index
  end

end
