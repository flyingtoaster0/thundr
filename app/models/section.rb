class Section < ActiveRecord::Base
  belongs_to :course
  has_many :klasses

  #attr_accessible :start_date, :end_date
end