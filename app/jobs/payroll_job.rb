class PayrollJob < Struct.new(:emp_id)
  def perform
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
  end
  def success(job) 
    AppMailer.payroll_complete(Employee.first).deliver_later
  end
end