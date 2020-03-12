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

  def full_name
    f_name = first_name + ' ' + last_name
    f_name.titleize
  end

  def income_tax(payable)
    annual_payable = payable * 12
    tax_slab = TaxSlab.where("income_start <= ? AND income_end > ? AND tax_slab_year_start <= ? AND tax_slab_year_end >= ?",annual_payable,annual_payable,Date.today, Date.today).first
    tax_slab.nil? ? 0 : (tax_slab.fixed_tax / 12) + ((payable - (tax_slab.income_start / 12)) * tax_slab.percentage_tax / 100)  
  end

  def generate_payslip(payroll)
  # Generate invoice
  Prawn::Document.new do |pdf|
    if image.attached?
      pdf.image StringIO.open(image.download), fit: [100, 100], position: :center, position: :center
  #  else
  #    pdf.image "public/default_avatar.png", fit: [100, 100], position: :center, position: :center
    end
    # Title
    pdf.text full_name, :size => 25, :align => :center

    # Client info
    pdf.text "Employee ##{id}", :align => :center

    pdf.text "Payroll for #{payroll.payroll_month.strftime("%B")} #{payroll.payroll_month.year.to_s}", :align => :center

    pdf.move_down 20

    # Items
    header = ['Type', 'Income', 'Deduction']
   # items = invoice.items.collect do |item|
    #  [item.quantity.to_s, item.description, number_to_currency(item.amount), number_to_currency(item.total)]
    #end this automatically adds to table. 
    
    items =  [["Base Salary:","#{payroll.base_salary}", "0"]] \
                  + [["Income Tax:", "0", "#{income_tax(payroll.tax)}"]] \

    pdf.table [header] + items, :header => true, :width => pdf.bounds.width,  :row_colors => %w{cccccc eeeeee} do
      row(-4..-1).borders = []
      row(-4..-1).column(2).align = :right
      row(0).style :font_style => :bold
      row(-1).style :font_style => :bold
    end
    
                     # :border_style => :grid, 
                     # :headers => header, 
                     # :width => pdf.bounds.width, 
                     # :row_colors => %w{cccccc eeeeee},
                     # :align => { 0 => :right, 1 => :left, 2 => :right, 3 => :right, 4 => :right }


    # Terms
#    if invoice.terms != ''
#      pdf.move_down 20
#      pdf.text 'Terms', :size => 18
#      pdf.text invoice.terms
#    end
#
#    # Notes
#    if invoice.notes != ''
#      pdf.move_down 20
#      pdf.text 'Notes', :size => 18
#      pdf.text invoice.notes
#    end

    # Footer
    pdf.draw_text "Generated at #{(Time.now)}", :at => [0, 0]
    pdf.move_down 20
    pdf.draw_text "It is a computer generated slip and does need a stamp", :at => [0, 20]

    io = StringIO.new pdf.render
    files.attach(io: io, content_type: 'application/pdf',filename: full_name + "_Payroll_"+ payroll.payroll_month.strftime("%B") + payroll.payroll_month.year.to_s + ".pdf")
    #files.analyze
  end
end
end