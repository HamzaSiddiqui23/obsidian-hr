class Payroll < ApplicationRecord
  belongs_to :employee

  scope :payroll_this_month, lambda { where(payroll_month: Date.today.beginning_of_month..Date.today.end_of_month) }

  before_validation :check_paid, on: :update

  def check_paid
    if paid
      adv = Advance.where(date: payroll_month..payroll_month.end_of_month, employee_id: employee_id, is_paid_back: false)
      adv.update_attributes(is_paid_back: true)
    end
  end

  def self.generate_payroll
    if !Payroll.where(payroll_month: Date.today.beginning_of_month).empty?
      return "Error: Payroll already exists for month"
    elsif
      @employees = Employee.all
      @employees.each do |e|
        @adv = e.advances.where(date: Date.today.beginning_of_month..Date.today.end_of_month).sum(:amount)
        @bonus = e.bonuses.where(date: Date.today.beginning_of_month..Date.today.end_of_month).sum(:amount)
        @ot = e.overtimes.where(date: Date.today.beginning_of_month..Date.today.end_of_month).sum(:number_of_hours) * ((e.employee_compensation.salary / 30)/ 8)
        @absence =  e.absences.where(date: Date.today.beginning_of_month..Date.today.end_of_month).sum(:quantity) * (e.employee_compensation.salary / 30)
        @adv_paid_back = e.advances.where(date: Date.today.beginning_of_month - 1.month..Date.today.end_of_month-1.month, is_paid_back: false).sum(:amount)
        @taxable = e.employee_compensation.salary + @adv + @ot - @absence - @adv_paid_back
        @payable= e.employee_compensation.salary + @adv + @ot + @bonus - @absence - @adv_paid_back
        @eobi = (@payable*e.employee_compensation.EOBI_percentage)/100 
        @tax = e.income_tax(@payable)
        Payroll.create!(employee_id: e.id, payroll_generated_date: Date.today, payroll_month: Date.today.beginning_of_month,base_salary: e.employee_compensation.salary,bonus: @bonus, overtime: @ot, advances: @adv,absence_deduction: @absence,advance_return: @adv_paid_back,taxable_amount: @taxable, actual_amount: @payable, eobi: @eobi, tax: @tax, gross_pay: @payable - @eobi - @tax, paid:false)
      end
      return "Payroll successfully generated"
    end
  end
end