class CreateCoursesSchedulesJoinTable < ActiveRecord::Migration
  def change
    create_table :courses_schedules, id: false do |t|
      t.integer :course_id
      t.integer :schedule_id
    end
  end
end
