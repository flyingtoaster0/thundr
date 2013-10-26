class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :department
      t.string :course_code
      t.string :name
      t.string :prerequisite
      t.text :description

      t.string :method
      t.float :credits
      t.timestamps
    end
  end
end
