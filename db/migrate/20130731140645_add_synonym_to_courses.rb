class AddSynonymToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :synonym, :integer
    add_column :courses, :method, :string
    add_column :courses, :link, :string
  end
end
