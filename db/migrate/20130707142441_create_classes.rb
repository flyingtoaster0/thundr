class CreateClasses < ActiveRecord::Migration
  def change
    create_table :classes do |t|
      t.string :day
      t.string :startTime
      t.string :endTime
      t.string :instructor
      t.string :campus
      t.string :room
      t.date :startDate
      t.date :endDate

      t.timestamps
    end
  end
end
