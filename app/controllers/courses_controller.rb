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
    @fall_listings = [@course.fall_lectures, @course.fall_labs, @course.fall_tutorials, @course.fall_practicals]
    @winter_listings = [@course.winter_lectures, @course.winter_labs, @course.winter_tutorials, @course.winter_practicals]
    @summer_listings = [@course.summer_lectures, @course.summer_labs, @course.summer_tutorials, @course.summer_practicals]
    @year_listings = [@course.year_lectures, @course.year_labs, @course.year_tutorials, @course.year_practicals]
    @listings = [@fall_listings, @winter_listings, @summer_listings, @year_listings].reject{|x| x.reject{|y| y.empty?}.empty?}
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
