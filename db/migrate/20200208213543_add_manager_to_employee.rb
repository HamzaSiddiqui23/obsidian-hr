class AddManagerToEmployee < ActiveRecord::Migration[5.2]
  def change
    change_table :employees do |t|
      t.integer :manager_id, :references => :employees
    end
  end
end
