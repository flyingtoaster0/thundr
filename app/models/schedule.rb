class Schedule < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :sections

  #attr_accessible :created, :name, :updated
end
