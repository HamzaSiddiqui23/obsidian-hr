class Employee < ApplicationRecord
  has_one :system_user
  has_one :employee_benefit_plan
  has_one :employee_compensation
  has_one_attached :image
  has_many :advances
  has_many :leaves
  has_many :absences
  has_many :overtimes
  has_many :bonuses
  has_many :payrolls
  accepts_nested_attributes_for :system_user
  accepts_nested_attributes_for :employee_benefit_plan
  accepts_nested_attributes_for :employee_compensation

  def full_name
    f_name = first_name + ' ' + last_name
    f_name.titleize
  end

  def income_tax(payable)
    annual_payable = payable * 12
    tax_slab = TaxSlab.where("income_start <= ? AND income_end > ? AND tax_slab_year_start <= ? AND tax_slab_year_end >= ?",annual_payable,annual_payable,Date.today, Date.today).first
    tax_slab.nil? ? 0 : (tax_slab.fixed_tax / 12) + ((payable - (tax_slab.income_start / 12)) * tax_slab.percentage_tax / 100)  
  end
end