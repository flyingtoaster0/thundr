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

  def search
    course_info = params[:q].split('-')
    @query = course_info[0] ? course_info[0] : ''
    dept_code = course_info[0]
    course_code = course_info[1]

    courses = nil

    #check by course code
    unless(Department.where('lower(deptCode) = ?', dept_code.downcase).blank?)
      if course_code

        limit = course_code.length
        while limit > 0 and courses.blank?
          courses = Course.where("lower(department) = ? AND code LIKE ?", dept_code.downcase, course_code[0..limit]+'%')
          limit -= 1
        end
      end

      courses = Course.where('lower(department) = ?', dept_code.downcase) if courses.blank?
    end

    #Checking by course title
    course_name = params[:q]
    #courses = nil

    limit = course_name.length
    while limit > 4 and courses.blank?
      courses = Course.where("lower(name) LIKE ?", '%'+course_name[0..limit].downcase+'%')
      limit -= 1
    end

    #check by instructor
    instructor_name = params[:q]
    courses = Course.where("lower(instructor) LIKE ?", '%'+instructor_name[0..limit].downcase+'%') if courses.blank?

    respond_to do |format|
      format.json { render :json => courses}
    end
  end
end