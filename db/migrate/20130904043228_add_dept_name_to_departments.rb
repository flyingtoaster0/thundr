class AddDeptNameToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :dept_name, :string
  end
end
