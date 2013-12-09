class Schedule < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :sections, -> {uniq}
  before_destroy {sections.clear}
end
