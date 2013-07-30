class Progress < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.integer :percent
      t.text :description
    end
  end
end
