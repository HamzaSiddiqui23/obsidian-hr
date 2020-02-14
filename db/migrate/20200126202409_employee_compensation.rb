class EmployeeCompensation < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_compensations do |t|
      t.integer :employee_id, :references => :employees
      t.integer :salary
      t.integer :EOBI_percentage
    end
  end
end
