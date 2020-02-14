class Absence < ApplicationRecord
  belongs_to :employee

  before_validation :can_add_absence, on: :create

  def can_add_absence
    leaves = Leave.where(date: date, employee_id: employee_id)
    abs = Absence.where(date: date, employee_id: employee_id)
    if !leaves.nil? && !abs.nil? 
      errors.add(:base, "Already Have Leaves/Absence Assigned on day")
      throw :abort
    end
  end
end