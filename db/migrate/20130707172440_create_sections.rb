class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.belongs_to :course
      t.string :department
      t.string :course_code
      t.string :section_code
      t.string :instructor
      t.date :start_date
      t.date :end_date
      t.string :season
      t.string :link
      t.integer :synonym
      t.string :method


      t.timestamps
    end
  end
end
