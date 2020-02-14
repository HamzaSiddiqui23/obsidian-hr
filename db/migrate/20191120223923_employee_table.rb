class EmployeeTable < ActiveRecord::Migration[5.1]
  def change
    create_table :employees  do |t|
      t.string    :first_name, null: false
      t.string    :last_name, null: false
      t.string    :cnic, null: false
      t.boolean   :can_login 
      t.date      :joining_date, null: false
      t.string    :office_location, null: false
      t.string    :employee_type, null: false
      t.string    :address
      t.string    :phone_number
      t.string    :email
      t.timestamps
    end
  end
end
