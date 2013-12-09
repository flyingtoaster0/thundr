class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :dept_code
      t.string :dept_name
    end
  end
end
