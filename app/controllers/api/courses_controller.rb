class API::CoursesController < ApplicationController
  def index
    @courses = Course.all
    respond_to do |format|
      format.json { render :json => @courses }
    end
  end

  def show
    @sections = Section.where('course_code = ? AND department = ?', params[:course_id], params[:department_id])
    respond_to do |format|
      format.json { render :json => @sections }
    end
  end

  def find_by_department
    @courses = Course.where('department = ? AND method != ? AND method!= ?', params[:department_id], 'LAB', 'TUT').order('course_code ASC')
    respond_to do |format|
      format.json { render :json => @courses }
    end
  end

  def full_course
    @section = Section.where('course_code = ? AND department = ? AND section_code = ?', params[:course_id], params[:department_id], params[:section])
    respond_to do |format|
      format.json { render :json => @section }
    end
  end

  def classes
    @classes = Klass.where(section_id: Section.select(:id).where('course_code = ? AND department = ? AND section_code = ?', params[:course_id], params[:department_id], params[:section]))
    respond_to do |format|
      format.json { render :json => @classes }
    end
  end

  def section_with_classes section_name
    section_hash = section_name.to_a.map(&:serializable_hash)
    section_name.zip(section_hash) do |o, n|
      k = o.classes.collect{|x| x}
      n['class_array'] = k
    end
    section_hash
  end

  def course_info
    @course = Course.where('course_code = ? AND department = ?', params[:course_id], params[:department_id]).first

    @all_info = Hash.new
    @all_info['department'] = @course.department
    @all_info['course_code'] = @course.course_code
    @all_info['name'] = @course.name
    @all_info['description'] = @course.description
    @all_info['credits'] = @course.credits
    @all_info['prerequisite'] = @course.prerequisite
    @all_info['method'] = @course.method

    # Add the summer and all-year courses after fixing them in courses.rb
    @all_info['fall'] = ['lectures'=> section_with_classes(@course.fall_lectures), 'labs'=> section_with_classes(@course.fall_labs), 'practicals'=> section_with_classes(@course.fall_practicals), 'tutorials'=> section_with_classes(@course.fall_tutorials)].first
    @all_info['winter'] = ['lectures'=> section_with_classes(@course.winter_lectures), 'labs'=> section_with_classes(@course.winter_labs), 'practicals'=> section_with_classes(@course.winter_practicals), 'tutorials'=> section_with_classes(@course.winter_tutorials)].first


    respond_to do |format|
      format.json { render :json => [@all_info] }
    end
  end


  def search
    courses = Array.new
    if params[:q].length > 3
      course_info = params[:q].split('-')
      @query = course_info[0] ? course_info[0] : ''
      dept_code = course_info[0]
      course_code = course_info[1]

      #check by course code
      unless(Department.where('"deptCode" = ?', dept_code.upcase).blank?)
        if course_code

          limit = course_code.length
          while limit > 0 and courses.blank?
            courses = Course.where("lower(department) = ? AND course_code LIKE ?", dept_code.downcase, course_code[0..limit]+'%')
            limit -= 1
          end
        end
        courses = Course.where('lower(department) = ?', dept_code.downcase) if courses.blank?
      end

      #Checking by course title
      course_name = params[:q].gsub('+',' ')
      #courses = nil

      limit = course_name.length
      while limit > 3 and courses.blank?
        courses = Course.where("lower(name) LIKE ?", '%'+course_name[0..limit].downcase+'%')
        limit -= 1
      end

      #check by instructor
      instructor_name = params[:q].gsub('+',' ')

      limit = instructor_name.length
      while limit > 3 and courses.blank?
        courses = Course.where(id: Section.select(:course_id).where("lower(instructor) LIKE ? AND method != ?", '%'+instructor_name[0..limit].downcase+'%', 'LAB'))
        limit -= 1
      end
    end
    respond_to do |format|
      format.json { render :json => courses}
    end
  end
end
