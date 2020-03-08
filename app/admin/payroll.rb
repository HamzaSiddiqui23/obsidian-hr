ActiveAdmin.register Payroll do

  scope :payroll_this_month, default: true

  actions :index

  filter :employee
  filter :paid
  filter :by_office_locations_in, label: 'Office Location', as: :select, collection: AppConstant::OFFICE
  filter :month, :as => :select, :collection => (Date::MONTHNAMES[1..12]).to_a
  filter :payroll_year, :as => :select, :collection => (2019..Time.now.year).to_a


  xls() do
    after_filter do |sheet|
      currency_format = Spreadsheet::Format.new number_format: 'NUMBER', :color => :blue, :weight => :bold, :size => 18
      sheet.insert_row sheet.rows.count, ['TOTAL',"=SUM(N2:N#{sheet.rows.count})"]
      @data_row = sheet.rows.count - 1
      #sheet.row(@data_row).formats[0] = currency_format
      @row = sheet.row(@data_row)
      @row.set_format(1,currency_format)
    end
  end

  before_action do
    if params[:generate_payroll] == 'true'
      msg = Payroll.check_payroll_status
      flash[:error] = msg
      if !msg.include? "Error" 
        Payroll.delay.generate_payroll
        redirect_to admin_payrolls_path
      end
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
    column :office_location
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