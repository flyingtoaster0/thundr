class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :code
      t.string :name
      t.text :description
      t.string :prerequisite
      t.string :instructor

      t.timestamps
    end
  end
end
