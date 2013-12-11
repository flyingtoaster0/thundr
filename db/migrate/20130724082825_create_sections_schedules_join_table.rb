class CreateSectionsSchedulesJoinTable < ActiveRecord::Migration
  def change
    create_table :schedules_sections, id: false do |t|
      t.integer :section_id
      t.integer :schedule_id
    end
  end
end
