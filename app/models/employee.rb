class Employee < ApplicationRecord
  has_one :system_user
  has_one :employee_benefit_plan
  has_one :employee_compensation
  has_one_attached :image
  has_many :leaves
  has_many :absences
  has_many :overtimes
  has_many :bonuses
  accepts_nested_attributes_for :system_user
  accepts_nested_attributes_for :employee_benefit_plan
  accepts_nested_attributes_for :employee_compensation

  def full_name
    f_name = first_name + ' ' + last_name
    f_name.titleize
  end

  def income_tax
    annual_salary = employee_compensation.salary * 12
    tax_slab = TaxSlab.where("income_start <= ? AND income_end > ? AND tax_slab_year_start <= ? AND tax_slab_year_end >= ?",annual_salary,annual_salary,Date.today, Date.today).first
    tax_slab.nil? ? 0 : tax_slab.fixed_tax + (employee_compensation.salary * tax_slab.percentage_tax / 100)  
  end

end
