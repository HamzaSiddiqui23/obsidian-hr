class Payroll < ApplicationRecord
  belongs_to :employee


  ransacker :by_office_locations, formatter: proc{ |v|
    data = Payroll.joins(:employee).where(employees: {office_location: v}).pluck(:id)
    data.present? ? data : nil
  }do |parent|
  parent.table[:id]
  end
  scope :payroll_year_eq, ->(payroll_year) { where("date_part('year', payroll_month) = ?", payroll_year) }
  scope :payroll_this_month, lambda { where(payroll_month: Date.today.beginning_of_month..Date.today.end_of_month) }
  scope :month_eq, ->(month) { where("date_part('month', payroll_month) = ?", Date::MONTHNAMES.index(month)) }

  before_validation :check_paid, on: :update

  def self.ransackable_scopes(_auth_object = nil)
    [:month_eq,:payroll_year_eq]
  end

  def self.month_totals
    c_payrolls = Payroll.payroll_this_month
    @bonus = 0
    @overtime = 0
    @advances = 0
    @absence_deduct = 0
    @advance_return = 0
    @eobi = 0
    @tax = 0
    @gross_pay = 0
    c_payrolls.each do |p|
      @bonus = @bonus + p.bonus
      @overtime = @overtime + p.overtime
      @advances = @advances + p.advances
      @absence_deduct = @absence_deduct + p.absence_deduction
      @advance_return = @advance_return + p.advance_return
      @eobi = @eobi + p.eobi
      @tax = @tax + p.tax
      @gross_pay = @gross_pay + p.gross_pay
    end
    payroll_totals = [@bonus, @overtime, @advances, @absence_deduct, @advance_return, @eobi, @tax, @gross_pay]
  end

  def office_location
    Employee.find(employee_id).office_location
  end

  def check_paid
    if paid
      adv = Advance.where(date: payroll_month..payroll_month.end_of_month, employee_id: employee_id, is_paid_back: false)
      adv.update_attributes(is_paid_back: true)
    end
  end

  def self.check_payroll_status
    if !Payroll.where(payroll_month: Date.today.beginning_of_month).empty?
      return "Error: Payroll already exists for " + Date.today.strftime("%B")
    else
      return "Payroll is being generated. You will be notified once it is complete"
    end
  end

  def self.generate_payroll
     Delayed::Job.enqueue PayrollJob.new(Employee.first.id)
  end
end