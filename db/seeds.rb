# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Employee.count == 0
  #Create first employee
  emp = Employee.create(first_name:'Hamza',last_name:'Siddiqui',cnic:'61101-7829324-7',can_login:'true',joining_date: '19/11/2019', office_location: 'Islamabad', employee_type: 'Permanent', address:'House#116, Street#19, F-11/2', phone_number: '03218502646', email:'hamza_siddiqui_2@hotmail.com')
  SystemUser.create(employee_id: emp.id, user_name:'hamza.siddiqui',password:'password',password_confirmation:'password',system_role:'Admin')
  EmployeeCompensation.create(employee_id: emp.id, salary:'88800', EOBI_percentage: '5')
  EmployeeBenefitPlan.create(employee_id: emp.id, annual_leaves: 18, casual_leaves: 10, compensation_leaves: 0, sick_leaves: 8, health_insurance: true)
end

if TaxSlab.count == 0
  #Create Tax Slabs 2019-2020
  TaxSlab.create(income_start: 0, income_end: 600000, fixed_tax: 0, percentage_tax: 0, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 600000, income_end: 1200000, fixed_tax: 0, percentage_tax: 5, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 1200000, income_end: 1800000, fixed_tax: 30000, percentage_tax: 10, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 1800000, income_end: 2500000, fixed_tax: 90000, percentage_tax: 15, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 2500000, income_end: 3500000, fixed_tax: 195000, percentage_tax: 17.5, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 3500000, income_end: 5000000, fixed_tax: 370000, percentage_tax: 20, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 5000000, income_end: 8000000, fixed_tax: 670000, percentage_tax: 22.5, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 8000000, income_end: 12000000, fixed_tax: 1345000, percentage_tax: 25, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 12000000, income_end: 30000000, fixed_tax: 2345000, percentage_tax: 27.5, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 30000000, income_end: 50000000, fixed_tax: 7295000, percentage_tax: 30, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 50000000, income_end: 75000000, fixed_tax: 13295000, percentage_tax: 32.5, tax_slab_year_start:'2019-01-01')
  TaxSlab.create(income_start: 75000000, income_end: Float::INFINITY, fixed_tax: 21420000, percentage_tax: 35, tax_slab_year_start:'2019-01-01')
end

emp = Employee.where(status: nil)
emp.each do |e|
  e.status = "Active"
  e.save
end