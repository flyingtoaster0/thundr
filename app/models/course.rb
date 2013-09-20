class Course < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  has_and_belongs_to_many :carts
  attr_accessible :campus, :name, :link, :method, :code, :description, :endDate, :endTime, :fri, :instructor, :mon, :name, :notes, :room, :sat, :startDate, :startTime, :sun, :thu, :tue, :wed

  def course_code
    department + '-' + code
  end
end
