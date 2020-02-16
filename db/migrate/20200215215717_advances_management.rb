class AdvancesManagement < ActiveRecord::Migration[5.2]
  def change
    create_table :advances do |t|
      t.integer :employee_id, :references => :employees
      t.float   :amount
      t.date    :date
      t.string  :comments
      t.boolean :is_paid_back
      t.string  :approval_status
      t.string  :approved_by
    end
  end
end