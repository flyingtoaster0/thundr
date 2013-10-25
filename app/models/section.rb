class Section < ActiveRecord::Base
  belongs_to :course

  #attr_accessible :start_date, :end_date
end