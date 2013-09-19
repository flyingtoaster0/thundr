class Course < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  has_and_belongs_to_many :carts
  attr_accessible :campus, :name, :courseCode, :description, :endDate, :endTime, :fri, :instructor, :mon, :name, :notes, :room, :sat, :startDate, :startTime, :sun, :thu, :tue, :wed
end
