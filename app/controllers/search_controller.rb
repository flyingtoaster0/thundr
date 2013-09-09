class SearchController < ApplicationController
  def index
    course_info = params[:q].split('-')
    dept_code = course_info[0]
    course_code = course_info[1]

    if course_code
      course = Course.find_by_department_and_courseCode(dept_code, course_code)

      if course
        redirect_to('/courses/'+dept_code+'/'+course_code)
      end
    else
      department = Department.find_by_deptCode(dept_code)
      if department
        redirect_to('/departments/'+dept_code)
      end
    end
  end

end