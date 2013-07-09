class Course < ActiveRecord::Base
  attr_accessible :campus, :courseCode, :description, :endDate, :endTime, :fri, :instructor, :mon, :name, :notes, :room, :sat, :startDate, :startTime, :sun, :thu, :tue, :wed
end
