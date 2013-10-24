class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :section_code
      t.string :season


      t.timestamps
    end
  end
end
