class AddSectionToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :section, :string
  end
end
