class OvertimeManagement < ActiveRecord::Migration[5.2]
  def change
    create_table :overtimes do |t|
      t.integer :employee_id, :references => :employees
      t.integer :number_of_hours
      t.date    :date
      t.string  :reason
      t.string  :approved_by
      t.string  :approval_status
    end
  end
end
