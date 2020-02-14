class AddRoleToEmployee < ActiveRecord::Migration[5.2]
  def change
    change_table :employees do |t|
      t.string :title
    end
  end
end
