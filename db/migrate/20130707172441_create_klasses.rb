class CreateKlasses < ActiveRecord::Migration
  def change
    create_table :klasses do |t|
      t.belongs_to :section
      t.string :day
      t.string :start_time
      t.string :end_time
      t.string :campus
      t.string :room

      t.timestamps
    end
  end
end
