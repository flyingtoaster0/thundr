class CoursesController < ApplicationController


  def new
  end

  def create
    @course = Course.new(params[:course])

    @course.save
    redirect_to @course
  end

  def show
    @course = Course.find_by_department_and_code(params[:department_id], params[:id])
    x=5
  end

  def index
    @test = current_user
    @courses = Course.all
  end

  def search
    course_info = params[:q].split('-')
    dept_name = course_info[0]
    course_code = course_info[1]

    if course_code
      course = Course.find_by_department_and_code(dept_name, course_code)
      if course
        redirect_to(course)
      end
    else
      department = Department.find_by_deptCode(dept_name)
      if department
        #redirect to course listing for this department
      end
    end


    @query = params[:q]
  end

end
