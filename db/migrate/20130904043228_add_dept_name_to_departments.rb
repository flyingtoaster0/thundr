class AddDeptNameToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :deptName, :string
  end
end
