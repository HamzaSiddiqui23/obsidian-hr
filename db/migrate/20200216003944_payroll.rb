class Payroll < ActiveRecord::Migration[5.2]
  def change
    create_table :payrolls do |t|
      t.integer :employee_id, :references => :employees
      t.date    :payroll_generated_date
      t.date    :payroll_month
      t.integer :base_salary
      t.integer :bonus
      t.integer :overtime
      t.integer :advances
      t.integer :absence_deduction
      t.integer :advance_return
      t.integer :taxable_amount
      t.integer :actual_amount
      t.integer :eobi
      t.integer :tax
      t.integer :gross_pay
      t.boolean :paid
    end
  end
end
