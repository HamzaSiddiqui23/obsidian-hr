# frozen_string_literal: true

class DeviseCreateSystemUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :system_users do |t|
      ## Database authenticatable
      t.string :user_name,            null: false
      t.string :encrypted_password,   null: false
      t.string :system_role
      t.string :employee_id,          :references => :employees
      t.string :email
      t.timestamps null: false
    end

    add_index :system_users, :user_name,                unique: true
  end
end
