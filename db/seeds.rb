# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

emp = Employee.create(first_name:'Hamza',last_name:'Siddiqui',cnic:'61101-7829324-7',can_login:'true',joining_date: '19/11/2019', office_location: 'Islamabad', employee_type: 'Permanent', address:'House#116, Street#19, F-11/2', phone_number: '03218502646', email:'hamza_siddiqui_2@hotmail.com')
SystemUser.create(employee_id: emp.id, user_name:'hamza.siddiqui',password:'password',password_confirmation:'password',system_role:'Admin')
EmployeeCompensation.create(employee_id: emp.id, salary:'88800', EOBI_percentage: '5')
EmployeeBenefitPlan.create(employee_id: emp.id, annual_leaves: 18, casual_leaves: 10, compensation_leaves: 0, sick_leaves: 8, health_insurance: true)