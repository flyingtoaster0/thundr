class AddCreditsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :credits, :float
  end
end
