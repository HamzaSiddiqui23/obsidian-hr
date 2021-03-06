ActiveAdmin.register Employee do

  permit_params :first_name, :last_name, :title,:image, :cnic,:manager_id, :can_login, :joining_date, :do_not_rehire, :reason_for_leaving, :status, :office_location, :employee_type, :address, :phone_number, :email, :files, system_user_attributes: [:id, :user_name, :password, :system_role], employee_compensation_attributes: [:id, :salary, :EOBI_percentage], employee_benefit_plan_attributes: [:id, :annual_leaves, :casual_leaves, :compensation_leaves, :sick_leaves, :health_insurance]
  
  form partial: 'form'
 
  filter :first_name
  filter :last_name
  filter :title
  filter :manager_id, as: :select, collection: Employee.all
  filter :employee_type,as: :select, collection: AppConstant::EMPLOYEE_TYPE
  filter :status, collection: AppConstant::EMPLOYEE_STATUS
  
  actions :all, except: :destroy

  scope :active, default: true
  scope :inactive

  before_action do
    if params[:deactivate] == "true"
      if !Employee.where(manager_id: resource.id).empty?
        flash[:error] = "Please move reportees to different Manager to remove this employee"
      end
    end
  end

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
    column :status
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
      row :status
      if resource.status != "Active"
        row :reason_for_leaving
        row :do_not_rehire
      end
    end
  end
  show :title => :full_name do
    attributes_table do
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
    panel 'Attachments', only: :show do
      table_for employee.files do 
        column :file_name do |f|
          f.filename
        end
        column :preview do |f|
          link_to "Preview", rails_blob_path(f, disposition: 'preview')
        end
        column :download do |f|
          link_to "Download", rails_blob_path(f, disposition: 'attachment')
        end
        #column :delete do |f|
        #  link_to "Delete", f.purge
        #end
      end
    end
  end

  action_item :deactivate_employee, only: :show, :if => proc { resource.status == "Active" }  do
    link_to "Deactivate Employee", Employee.where(manager_id: resource.id).empty? ? edit_admin_employee_path(id: resource.id, deactivate: true) : admin_employee_path(id: resource.id, deactivate: true)
  end  

  action_item :add_advance, only: :show, :if => proc { resource.status == "Active" } do
    link_to "Add Attachment", edit_admin_employee_path(id: resource.id, attachment: true)
  end

  action_item :view_hierarchy, only: :show, :if => proc { resource.status == "Active" } do
    link_to "View Hierarchy", admin_hierarchy_path(id: resource.id)
  end

  action_item :add_leave, only: :show, :if => proc { resource.status == "Active" } do
    link_to "Add Leave", new_admin_leave_path(id: resource.id)
  end

  action_item :add_absence, only: :show, :if => proc { resource.status == "Active" } do
    link_to "Add Absence", new_admin_absence_path(id: resource.id)
  end

  action_item :add_overtime, only: :show, :if => proc { resource.status == "Active" } do
    link_to "Add Overtime", new_admin_overtime_path(id: resource.id)
  end

  action_item :add_bonus, only: :show, :if => proc { resource.status == "Active" } do
    link_to "Add Bonus/Allowance", new_admin_bonus_path(id: resource.id)
  end

  action_item :add_advance, only: :show, :if => proc { resource.status == "Active" } do
    link_to "Add Advance", new_admin_advance_path(id: resource.id)
  end
end