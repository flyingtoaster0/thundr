class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :name
      t.timestamps
      t.belongs_to :user, null: false
    end
  end
end
