class Course < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  has_and_belongs_to_many :carts
  has_many :sections
  #attr_accessible :campus, :name, :link, :method, :code, :description, :prerequisite, :endDate, :endTime, :fri, :instructor, :mon, :name, :notes, :room, :sat, :startDate, :startTime, :sun, :thu, :tue, :wed


  #@day_hash = {'Monday' => mon, 'Tuesday' => tue, 'Wednesday' => wed, 'Thursday' => thu, 'Friday' => fri, 'Saturday' => sat, 'Sunday' => sun }

  def department_and_course_code
    department + '-' + course_code
  end



  def method_name
    case method
      when 'LEC'
        'Lecture'
      when 'LAB'
        'Lab'
      when 'WEB'
        'Web'
      when 'TUT'
        'Tutorial'
      when 'PRA'
        department=='NURS' ? 'Clinical' : 'Practical'
      when 'VID'
        'Video'
    end
  end


  def all_seasons

    return Section.where(:department => department, :course_code => course_code).collect{|s| s.section_code[0]}

    #return Section.find_all_by_department_and_code(department, code).collect{|c| c.section[0]}
  end

=begin
  def day_array
    [mon, tue, wed, thu, fri, sat, sun].zip(['Monday',
                                            'Tuesday',
                                            'Wednesday',
                                            'Thursday',
                                            'Friday',
                                            'Saturday',
                                            'Sunday']).collect{|x,d| x ? d : nil}.reject{|y| not y}
  end

  def start_date
    startDate ? startDate.strftime('%b ') + startDate.strftime('%e').to_i.ordinalize + startDate.strftime(', %Y') : ''
  end

  def end_date
    endDate ? endDate.strftime('%b ') + endDate.strftime('%e').to_i.ordinalize + endDate.strftime(', %Y') : ''
  end


=end

  def fall_lectures

    Section.where('department = ? AND course_code = ? AND section_code like ?', department, course_code, 'F%')
    #Course.find_all_by_department_and_code(department, code, :conditions => ['section like ?', 'F%'])
  end

  def fall_labs
    Section.where('link = ? AND method = ? AND section_code like ?', department_and_course_code, 'LAB', 'F%')
    #Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'LAB', 'F%'])
  end

  def fall_tutorials

    Section.where('link = ? AND method = ? AND section_code like ?', department_and_course_code, 'TUT', 'F%')
    #Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'TUT', 'F%'])
  end

  def fall_practicals

    Section.where('link = ? AND method = ? AND section_code like ?', department_and_course_code, 'PRA', 'F%')
    #Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'PRA', 'F%'])
  end


  def winter_lectures
    Section.where('department = ? AND course_code = ? AND section_code like ?', department, course_code, 'W%')
  end

  def winter_labs
    Section.where('link = ? AND method = ? AND section_code like ?', department_and_course_code, 'LAB', 'W%')
  end

  def winter_tutorials
    Section.where('link = ? AND method = ? AND section_code like ?', department_and_course_code, 'TUT', 'W%')
  end

  def winter_practicals
    Section.where('link = ? AND method = ? AND section_code like ?', department_and_course_code, 'PRA', 'W%')
  end

=begin
  def summer_lectures
    Course.find_all_by_department_and_code(department, code, :conditions => ['section like ?', 'S%'])
  end

  def summer_labs
    Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'LAB', 'S%'])
  end

  def summer_tutorials
    Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'TUT', 'S%'])
  end

  def summer_practicals
    Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'PRA', 'S%'])
  end

  
  def year_lectures
    Course.find_all_by_department_and_code(department, code, :conditions => ['section like ?', 'Y%'])
  end

  def year_labs
    Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'LAB', 'Y%'])
  end

  def year_tutorials
    Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'TUT', 'Y%'])
  end

  def year_practicals
    Course.find_all_by_link(course_code, :conditions => ['method = ? and section like ?', 'PRA', 'Y%'])
  end
=end

end
