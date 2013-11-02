class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :dept_code
    end
  end
end
