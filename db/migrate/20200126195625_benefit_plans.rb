class BenefitPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_benefit_plans do |t|
      t.float :annual_leaves
      t.float :casual_leaves
      t.float :compensation_leaves
      t.float :sick_leaves
      t.boolean :health_insurance
      t.integer :employee_id, :references => :employees
    end
  end
end
