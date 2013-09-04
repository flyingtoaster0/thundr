class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :deptCode
    end
  end
end
