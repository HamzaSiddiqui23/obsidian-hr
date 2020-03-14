class Employee < ApplicationRecord
  has_one :system_user
  has_one :employee_benefit_plan
  has_one :employee_compensation
  has_one_attached :image
  has_many_attached :files
  has_many :advances
  has_many :leaves
  has_many :absences
  has_many :overtimes
  has_many :bonuses
  has_many :payrolls
  has_many :delayed_jobs
  accepts_nested_attributes_for :system_user
  accepts_nested_attributes_for :employee_benefit_plan
  accepts_nested_attributes_for :employee_compensation

  before_create :update_status

  after_create :generate_contract

  scope :active, lambda { where(status: "Active") }
  scope :inactive, lambda { where.not(status: "Active")}

  def full_name
    f_name = first_name + ' ' + last_name
    f_name.titleize
  end

  def update_status
    self.status = 'Active'
  end

  def income_tax(payable)
    annual_payable = payable * 12
    tax_slab = TaxSlab.where("income_start <= ? AND income_end > ? AND tax_slab_year_start <= ? AND tax_slab_year_end >= ?",annual_payable,annual_payable,Date.today, Date.today).first
    tax_slab.nil? ? 0 : (tax_slab.fixed_tax / 12) + ((payable - (tax_slab.income_start / 12)) * tax_slab.percentage_tax / 100)  
  end

  def generate_payslip(payroll)
    Prawn::Document.new do |pdf|
      #Company Info
      pdf.image "public/pectlogo.png", fit:[200,200], position: :center
      pdf.text "Suite#3, First Floor, Panther Plaza, F-8 Markaz", :align => :center
      pdf.text "+92 51 2817575-8", :align => :center
      pdf.text "pect@pect.com.pk", :align => :center
      pdf.move_down 20
      #EmployeeInfo
      if image.attached?
        pdf.image StringIO.open(image.download), fit: [100, 100], position: :center
      else
        pdf.image "public/default_avatar.png", fit: [100, 100], position: :center
      end
      pdf.move_down 10
      pdf.text full_name, :size => 25, :align => :center
      pdf.text "Employee ##{id}", :align => :center
      pdf.text "Payroll for #{payroll.payroll_month.strftime("%B")} #{payroll.payroll_month.year.to_s}", :align => :center
      pdf.move_down 20
      #Table
      header = ['Type', 'Income', 'Deduction']
      items =  [["Base Salary","#{payroll.base_salary}", "0"]] \
            +  [["Bonuses","#{payroll.bonus}", "0"]] \
            +  [["Advances","#{payroll.advances}", "0"]] \
            +  [["Absence Deductions","0", "#{payroll.absence_deduction}"]] \
            +  [["Advance Returns","0", "#{payroll.advance_return}"]] \
            +  [["EOBI", "0", "#{payroll.eobi}"]] \
            +  [["Income Tax:", "0", "#{payroll.tax}"]] \
            +  [["","Gross Pay","#{payroll.gross_pay}"]]

      pdf.table [header] + items, :header => true, :width => pdf.bounds.width,  :row_colors => %w{cccccc eeeeee} do
        row(-1).column(0).borders = []
        row(-1).align = :right
        row(0).style :font_style => :bold
        row(-1).style :font_style => :bold
      end
      #Footer
      pdf.draw_text "Generated at #{(Time.now)}", :at => [0, 0]
      pdf.move_down 20
      pdf.draw_text "It is a computer generated slip and does not need a stamp or signature", :at => [0, 20]

      io = StringIO.new pdf.render
      files.attach(io: io, content_type: 'application/pdf',filename: full_name + "_Payroll_"+ payroll.payroll_month.strftime("%B") + payroll.payroll_month.year.to_s + ".pdf")
    end
  end

  def generate_contract
    tfile = File.open("public/Contract.txt")
    tdata = tfile.read
    tdata.sub! '{NAME}', full_name
    tdata.sub! '{SALARY}', employee_compensation.salary.to_s
    tdata.sub! '{EOBI}', employee_compensation.EOBI_percentage.to_s
    tdata.sub! '{ANNUALLEAVES}', employee_benefit_plan.annual_leaves.to_s
    Prawn::Document.new do |pdf|
      pdf.text tdata
      io = StringIO.new pdf.render
      files.attach(io: io, content_type: 'application/pdf',filename: full_name+"_Contract.pdf")
    end
    tfile.close
  end
end