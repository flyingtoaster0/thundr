class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :code
      t.string :name
      t.text :description
      t.string :prerequisite
      t.string :campus
      t.string :room
      t.date :startDate
      t.date :endDate
      t.boolean :mon
      t.boolean :tue
      t.boolean :wed
      t.boolean :thu
      t.boolean :fri
      t.boolean :sat
      t.boolean :sun
      t.time :startTime
      t.time :endTime
      t.string :instructor
      t.text :notes

      t.timestamps
    end
  end
end
