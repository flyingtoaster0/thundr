class CreateClasses < ActiveRecord::Migration
  def change
    create_table :classes do |t|
      t.string :day
      t.string :start_time
      t.string :end_time
      t.string :campus
      t.string :room
      t.integer :section_id

      t.timestamps
    end
  end
end
