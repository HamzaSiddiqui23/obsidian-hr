ActiveAdmin.register Payroll do

  scope :payroll_this_month, default: true

  actions :index

  filter :employee
  filter :paid

  before_action do
    if params[:generate_payroll] == 'true'
      msg = Payroll.generate_payroll
      flash[:error] = msg
      redirect_to admin_payrolls_path
    end
  end

  batch_action :mark_paid do |ids|
    batch_action_collection.find(ids).each do |pr|
      pr.update_attributes(paid: true)
    end
    redirect_to collection_path, alert: "Payroll has been paid"
  end

  index do
    selectable_column
    column :employee
    column :base_salary
    column :bonus
    column :overtime
    column :advances
    column :absence_deduction
    column :advance_return
    column :taxable_amount
    column :actual_amount
    column :eobi
    column :tax
    column :gross_pay
    column :paid
  end

  action_item :generate_payroll, only: :index do
    link_to "Generate Payroll", admin_payrolls_path({ generate_payroll: true })
  end

end