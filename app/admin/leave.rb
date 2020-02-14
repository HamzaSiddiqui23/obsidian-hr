ActiveAdmin.register Leave do
  menu parent: 'Approvals'

  permit_params :leave_type,:quantity, :employee_id, :date, :comments, :require_approval

  scope :approvals, default: true

  filter :employee

  batch_action :batch_approve do |ids|
    batch_action_collection.find(ids).each do |leave|
      leave.update_attributes(approval_status: "Approved")
    end
    redirect_to collection_path, alert: "The Leave Has Been Approved."
  end

  batch_action :batch_reject do |ids|
    batch_action_collection.find(ids).each do |leave|
      leave.update_attributes(approval_status: "Rejected")
      leave.rejected_leaves_readd
    end
    redirect_to collection_path, alert: "The Leave Has Been Rejected."
  end

  controller do
    def create
      create! { |success, failure|
        success.html { redirect_to admin_employee_path(resource.employee_id), :notice => "Leave has been added" }
        failure.html do
          flash[:error] = "Error : #{resource.errors.full_messages.join(',')}"
          redirect_back(fallback_location: admin_employees_path)
        end
      }
    end
    def check_for_action
      if params[:action_type] == "Approve"
        @leave_to_approve = Leave.find(params[:leave_id].to_i)
        @leave_to_approve.update_attributes(approval_status: "Approved", approved_by: current_system_user.name)
        flash[:error] = "Leave has been Approved"
      elsif params[:action_type] == "Reject"
        @leave_to_reject = Leave.find(params[:leave_id].to_i)
        @leave_to_reject.update_attributes(approval_status: "Rejected", approved_by: current_system_user.name)
        @leave_to_reject.rejected_leaves_readd
        flash[:error] = "Leave has been Rejected"
      end
    end

    def render(*args)
      check_for_action
      super
    end
  end

  index :title => 'Leave Approvals' do
    selectable_column
    column :employee
    column :leave_type
    column :quantity
    column :date
    column :approval_status
    column 'Approve' do |i|
      link_to "Approve", admin_leaves_path({ leave_id: i.id, action_type: "Approve" })
    end
    column 'Reject' do |i|
      link_to "Reject", admin_leaves_path({ leave_id: i.id, action_type: "Reject" })
    end
  end


  show do
    attributes_table do
      row :employee
      row :leave_type
      row :date
      row :quantity
      row :comments
      row :approval_status
      row :approved_by
    end
  end

  form  do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Leave Details' do
      f.input :leave_type, as: :select, collection: AppConstant::LEAVE_TYPE, include_blank: false
      f.input :quantity, as: :select, collection: AppConstant::LEAVE_QUANTITY, include_blank: false
      if params[:id].nil?
        f.input :employee_id, as: :select, :collection => Employee.all, include_blank: false, :input_html => { :id => "emp_id" }
      else
        f.input :employee_id, as: :select, :collection => Employee.where(id: params[:id].to_i), selected: params[:id].to_i, include_blank: false, :input_html => { :id => "emp_id" }
      end
      f.input :date, as: :date_picker
      f.input :comments
      f.input :require_approval
    end
    f.actions
  end
end