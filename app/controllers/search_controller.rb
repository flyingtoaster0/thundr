class SearchController < ApplicationController
  def index
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

        if courses.length == 1
          redirect_to('/courses/'+dept_code+'/'+courses.first[:code])
        elsif courses.length > 1
          #output a nice results page
        end
      end


      department = Department.where('lower(deptCode) = ?', dept_code.downcase)
      unless department.blank?
        redirect_to('/departments/'+dept_code.upcase)
      end
    end


    #Checking by course title
    course_name = params[:q]
    courses = nil

    limit = course_name.length
    while limit > 4 and courses.blank?
      courses = Course.where("lower(name) LIKE ?", '%'+course_name[0..limit].downcase+'%')
      limit -= 1
    end

    if courses.length == 1
      redirect_to('/courses/'+dept_code+'/'+courses.first[:code])
    elsif courses.length > 1
      #output a nice results page
    end


    #check by instructor
    instructor_name = params[:q]
    courses = Course.where("lower(instructor) LIKE ?", '%'+instructor_name[0..limit].downcase+'%')

    if courses.length == 1
      redirect_to('/courses/'+dept_code+'/'+courses.first[:code])
    elsif courses.length > 1
      #output a nice results page
    end



  end
end
