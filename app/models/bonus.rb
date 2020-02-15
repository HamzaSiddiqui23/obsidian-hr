class Bonus < ApplicationRecord
  belongs_to :employee

  before_validation :set_default_approval, on: :create

  scope :approvals, lambda { where(approval_status: "Pending") }

  def set_default_approval
    Employee.find(employee_id).manager_id.nil? ? self.approval_status = 'Approved' : self.approval_status = 'Pending'
    self.date = Date.today
  end

end