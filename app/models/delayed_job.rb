class DelayedJob < ApplicationRecord
  belongs_to :employee
  before_validation :set_user, on: :create

  def set_user
    self.employee_id = current_system_user.employee.id
  end 
  
end