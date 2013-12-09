class CreateRememberTokens < ActiveRecord::Migration
  def change
    create_table :remember_tokens do |t|
      t.string :token
      t.integer :user_id
      t.date :accessed_at
    end
  end
end
