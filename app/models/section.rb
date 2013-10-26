class Section < ActiveRecord::Base
  belongs_to :course
  has_many :klasses



end