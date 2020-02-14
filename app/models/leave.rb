class Leave < ApplicationRecord
  belongs_to :employee


  scope :approvals, lambda { where(approval_status: "Pending") }

  before_validation :set_default_approval, on: :create

  def set_default_approval
    if require_approval
      Employee.find(employee_id).manager_id.nil? ? self.approval_status = 'Approved' : self.approval_status = 'Pending'
    else
      self.approval_status = 'Not Required'
    end
    if check_leaves_on_day
      true
    else
      errors.add(:base, "Already Have Leaves Assigned on day")
      throw :abort
    end
    if self.enough_leaves
      true
    else
      errors.add(:base, "Not Enough Leaves of Selected type")
      throw :abort
    end
  end

  def rejected_leaves_readd
    ebp = Employee.find(employee_id).employee_benefit_plan
    if leave_type == 'Annual'
      ebp.annual_leaves = ebp.annual_leaves + quantity
      ebp.save!
    elsif leave_type == 'Casual'
      ebp.casual_leaves = ebp.casual_leaves + quantity
      ebp.save!
    elsif leave_type == 'Sick'
      ebp.sick_leaves = ebp.sick_leaves + quantity
      ebp.save!
    elsif leave_type == 'Compensation'
      ebp.compensation_leaves = ebp.compensation_leaves + quantity
      ebp.save!
    end
  end

  def check_leaves_on_day
    el = Employee.find(employee_id).leaves.where(date: date)
    if el.empty?
      return true
    else
      return false
    end
  end

  def enough_leaves
    ebp = Employee.find(employee_id).employee_benefit_plan
    if leave_type == 'Annual'
      if ebp.annual_leaves >= quantity
        ebp.annual_leaves = ebp.annual_leaves - quantity
        ebp.save!
        return true
      end
    elsif leave_type == 'Casual'
      if ebp.casual_leaves >= quantity
        ebp.casual_leaves = ebp.casual_leaves - quantity
        ebp.save!
        return true
      end
    elsif leave_type == 'Sick'
      if ebp.sick_leaves >= quantity
        ebp.sick_leaves = ebp.sick_leaves - quantity
        ebp.save!
        return true
      end
    elsif leave_type == 'Compensation'
      if ebp.compensation_leaves >= quantity
        ebp.compensation_leaves = ebp.compensation_leaves - quantity
        ebp.save!
        return true
      end
    end
    return false
  end
end