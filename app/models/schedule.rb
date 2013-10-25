class Schedule < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :courses

  #attr_accessible :created, :name, :updated
end
