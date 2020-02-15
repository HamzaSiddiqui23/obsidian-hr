ActiveAdmin.register Employee do

  permit_params :first_name, :last_name, :title,:image, :cnic,:manager_id, :can_login, :joining_date, :office_location, :employee_type, :address, :phone_number, :email, system_user_attributes: [:id, :user_name, :password, :system_role], employee_compensation_attributes: [:id, :salary, :EOBI_percentage], employee_benefit_plan_attributes: [:id, :annual_leaves, :casual_leaves, :compensation_leaves, :sick_leaves, :health_insurance]
  
  form partial: 'form'
 
  filter :first_name
  filter :last_name
  filter :title
  filter :manager_id, as: :select, collection: Employee.all
  filter :employee_type,as: :select, collection: AppConstant::EMPLOYEE_TYPE
  
  actions :all, except: :destroy  

  index do
    column 'Employee' do |o|
      link_to o.full_name, 'employees/' + o.id.to_s
    end
    column :title
    column :email
    column :phone_number
    column :cnic
    column :manager do |m|
      m.manager_id.nil? ? nil : Employee.find(m.manager_id).full_name
    end
    column :can_login
    column :employee_type
  end

  sidebar 'Employee', :only => :show do
    attributes_table do
      row :image do |ad|
        if ad.image.attached? 
          image_tag url_for(ad.image), width: 200, height: 200
        end
      end
      row :first_name
      row :last_name
      row :manager do |m|
        m.manager_id.nil? ? nil : Employee.find(m.manager_id).full_name
      end
      row :cnic
      row :can_login
      row :title
      row :employee_type,as: :select, collection: AppConstant::EMPLOYEE_TYPE
    end
  end
  show :title => :full_name do
    attributes_table do
      row :income_tax
      row :joining_date
      row :office_location,as: :select, collection: AppConstant::OFFICE 
      row :address
      row :phone_number
      row :email
      row 'User name' do |u|
        u.system_user.user_name
      end
      row 'System Role' do |u|
        u.system_user.system_role
      end
      row 'Current Salary' do |u|
        u.employee_compensation.salary
      end
      row 'EOBI' do |u|
        u.employee_compensation.EOBI_percentage
      end      
    end
    panel 'Benefit Details', only: :show do
      table_for employee.employee_benefit_plan do
        column :annual_leaves
        column :casual_leaves
        column :compensation_leaves
        column :sick_leaves
        column :health_insurance
      end
    end
  end

  action_item :print_payslip, only: :show  do
    link_to "Payslip", admin_payroll_path(id: resource.id,payroll: true)
  end

  action_item :view_hierarchy, only: :show  do
    link_to "View Hierarchy", admin_hierarchy_path(id: resource.id)
  end

  action_item :add_leave, only: :show  do
    link_to "Add Leave", new_admin_leave_path(id: resource.id)
  end

  action_item :add_absence, only: :show  do
    link_to "Add Absence", new_admin_absence_path(id: resource.id)
  end

  action_item :add_overtime, only: :show  do
    link_to "Add Overtime", new_admin_overtime_path(id: resource.id)
  end
end