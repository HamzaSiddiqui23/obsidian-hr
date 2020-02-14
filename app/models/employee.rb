class Employee < ApplicationRecord
  has_one :system_user
  has_one :employee_benefit_plan
  has_one :employee_compensation
  has_one_attached :image
  has_many :leaves
  has_many :absences
  accepts_nested_attributes_for :system_user
  accepts_nested_attributes_for :employee_benefit_plan
  accepts_nested_attributes_for :employee_compensation

  def full_name
    f_name = first_name + ' ' + last_name
    f_name.titleize
  end

end
