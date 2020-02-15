ActiveAdmin.register Bonus do
  menu parent: 'Approvals'

  permit_params :amount, :employee_id, :date, :bonus_type, :comments

  scope :approvals, default: true

  filter :employee
  filter :date

  batch_action :batch_approve do |ids|
    batch_action_collection.find(ids).each do |ot|
      ot.update_attributes(approval_status: "Approved")
    end
    redirect_to collection_path, alert: "The Bonus/Allowance Has Been Approved."
  end

  batch_action :batch_reject do |ids|
    batch_action_collection.find(ids).each do |ot|
      ot.update_attributes(approval_status: "Rejected")
    end
    redirect_to collection_path, alert: "The Bonus/Allowance Has Been Rejected."
  end

  controller do
    def create
      create! { |success, failure|
        success.html { redirect_to admin_employee_path(resource.employee_id), :notice => "Bonus/Allowance has been added" }
        failure.html do
          flash[:error] = "Error : #{resource.errors.full_messages.join(',')}"
          redirect_back(fallback_location: admin_employees_path)
        end
      }
    end
    def check_for_action
      if params[:action_type] == "Approve"
        @ot_to_approve = Bonus.find(params[:bonus_id].to_i)
        @ot_to_approve.update_attributes(approval_status: "Approved", approved_by: current_system_user.name)
        flash[:error] = "Bonus/Allowance has been Approved"
      elsif params[:action_type] == "Reject"
        @ot_to_reject = Bonus.find(params[:bonus_id].to_i)
        @ot_to_reject.update_attributes(approval_status: "Rejected", approved_by: current_system_user.name)
        flash[:error] = "Bonus/Allowance has been Rejected"
      end
    end

    def render(*args)
      check_for_action
      super
    end
  end

  index :title => 'Bonus/Allowance Approvals' do
    selectable_column
    column :employee
    column :amount
    column :bonus_type
    column :comments
    column :date
    column 'Approve' do |i|
      link_to "Approve", admin_bonuses_path({ bonus_id: i.id, action_type: "Approve" })
    end
    column 'Reject' do |i|
      link_to "Reject", admin_bonuses_path({ bonus_id: i.id, action_type: "Reject" })
    end
  end

  show do
    attributes_table do
      row :employee
      row :amount
      row :bonus_type
      row :comments
      row :approval_status
      row :approved_by
      row :date
    end
  end

  form  do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Bonus/Allowance Details' do
      if params[:id].nil?
        f.input :employee_id, as: :select, :collection => Employee.where(id: current_system_user.employee.id), include_blank: false, :input_html => { :id => "emp_id" }
      else
        f.input :employee_id, as: :select, :collection => Employee.where(id: params[:id].to_i), selected: params[:id].to_i, include_blank: false, :input_html => { :id => "emp_id" }
      end
      f.input :bonus_type, as: :select, :collection => AppConstant::BONUS_TYPE
      f.input :amount
      f.input :comments
    end
    f.actions
  end
end