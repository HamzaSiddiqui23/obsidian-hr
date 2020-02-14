class LeavesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :leaves do |t|
      t.string  :leave_type
      t.float   :quantity
      t.integer :employee_id, :references => :employees
      t.date    :date
      t.string  :comments
      t.boolean :require_approval
      t.string  :approval_status
      t.string  :approved_by
    end
  end
end
