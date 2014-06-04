class CoursesController < ApplicationController
  def new
  end

  def create
    @course = Course.new(params[:course])

    @course.save
    redirect_to @course
  end

  def show
    @course = Course.where(:department => params[:department_id], :course_code => params[:id]).first
    @fall_listings = [@course.fall_lectures, @course.fall_labs, @course.fall_tutorials, @course.fall_practicals]
    @winter_listings = [@course.winter_lectures, @course.winter_labs, @course.winter_tutorials, @course.winter_practicals]
    @summer_listings = []#[@course.summer_lectures, @course.summer_labs, @course.summer_tutorials, @course.summer_practicals]
    @year_listings = []#[@course.year_lectures, @course.year_labs, @course.year_tutorials, @course.year_practicals]
    @listings = [@fall_listings, @winter_listings, @summer_listings, @year_listings].reject{|x| x.reject{|y| y.empty?}.empty?}
    @user = current_user
  end

  def index
    @test = current_user
    @courses = Course.all
  end

  def search

    if params[:q].length > 3
      course_info = params[:q].split('-')
      @query = course_info[0] ? course_info[0] : ''
      dept_code = course_info[0]
      course_code = course_info[1]

      @courses = nil

      #check by course code if query is entirely numeric
      if /^\d+$/ =~ dept_code and dept_code.length == 4 then
        #query is just a course code
        @courses = Course.where("course_code = ?", dept_code)
        @courses unless @courses.blank?
      end

      #check by course code
      unless(Department.where('"dept_code" = ?', dept_code.upcase).blank?)
        if course_code

          limit = course_code.length
          while limit > 0 and @courses.blank?
            @courses = Course.where("lower(department) = ? AND course_code LIKE ?", dept_code.downcase, course_code[0..limit]+'%')
            limit -= 1
          end
        end

        @courses = Course.where('lower(department) = ?', dept_code.downcase) if @courses.blank?
      end

      p "DEPT_CODE: #{dept_code} COURSE_CODE: #{course_code}"

      #Checking by course title
      course_name = params[:q].gsub('+',' ')
      #courses = nil

      limit = course_name.length
      while limit > 3 and @courses.blank?
        @courses = Course.where("lower(name) LIKE ?", '%'+course_name[0..limit].downcase+'%')
        limit -= 1
      end

      #check by instructor
      instructor_name = params[:q].gsub('+',' ')

      limit = instructor_name.length
      while limit > 3 and @courses.blank?
        @courses = Course.where(id: Section.select(:course_id).where("lower(instructor) LIKE ? AND method != ?", '%'+instructor_name[0..limit].downcase+'%', 'LAB'))
      limit -= 1
      end
      #@courses = Course.where(query)

      #@courses = Course.where("lower(instructor) LIKE ?", '%'+instructor_name[0..limit].downcase+'%') if @courses.blank?

      #@courses = Array.new
      #@sections.each do |s|
      #  @courses.append Course.where("department = ? AND course_code = ?", s.department, s.course_code)
      #end



      #respond_to do |format|
      #  format.json { render :json => courses}
      #end
      z=5
    end
  end

end
