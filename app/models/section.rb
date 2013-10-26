class Section < ActiveRecord::Base
  belongs_to :course
  has_many :klasses


  def course_code_full
    department + '-' + course_code + '-' + section_code
  end

  def name
    Course.find(course_id).name
  end


  def season
    case section_code[0]
      when 'F'
        'Fall'
      when 'W'
        'Winter'
      when 'S'
        'Summer'
      when 'Y'
        'All-Year'
    end
  end




end