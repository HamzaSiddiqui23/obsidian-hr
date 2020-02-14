class AbsenceTable < ActiveRecord::Migration[5.2]
  def change
    create_table :absences do |t|
      t.integer :employee_id, :references => :employees
      t.date    :date
      t.string  :comment
      t.boolean :is_paid
    end
  end
end
