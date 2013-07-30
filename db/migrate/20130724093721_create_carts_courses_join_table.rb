class CreateCartsCoursesJoinTable < ActiveRecord::Migration
  def change
    create_table :courses_carts, id: false do |t|
      t.integer :course_id
      t.integer :cart_id
    end
  end
end
