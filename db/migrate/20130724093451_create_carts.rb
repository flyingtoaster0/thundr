class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|

      t.timestamps

      t.belongs_to :user
    end
  end
end
