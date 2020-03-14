class AddStatusToEmployee < ActiveRecord::Migration[5.2]
  def change
    change_table :employees do |t|
      t.string  :status
      t.string  :reason_for_leaving
      t.boolean :do_not_rehire, null: false, default: false
    end
  end
end