class BonusAllowanceManagementTable < ActiveRecord::Migration[5.2]
  def change
    create_table :bonuses do |t|
      t.integer :employee_id, :refrences => :employees
      t.date    :date
      t.float   :amount
      t.string  :bonus_type
      t.string  :comments
      t.string  :approval_status
      t.string  :approved_by
    end
  end
end