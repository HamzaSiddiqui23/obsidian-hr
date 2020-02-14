ActiveAdmin.register Overtime do
  menu parent: 'Approvals'

  permit_params :number_of_hours, :employee_id, :date, :reason

  scope :approvals, default: true

  filter :employee

  batch_action :batch_approve do |ids|
    batch_action_collection.find(ids).each do |ot|
      ot.update_attributes(approval_status: "Approved")
    end
    redirect_to collection_path, alert: "The Overtime Has Been Approved."
  end

  batch_action :batch_reject do |ids|
    batch_action_collection.find(ids).each do |ot|
      ot.update_attributes(approval_status: "Rejected")
      ot.rejected_leaves_readd
    end
    redirect_to collection_path, alert: "The Overtime Has Been Rejected."
  end

  controller do
    def create
      create! { |success, failure|
        success.html { redirect_to admin_employee_path(resource.employee_id), :notice => "Overtime has been added" }
        failure.html do
          flash[:error] = "Error : #{resource.errors.full_messages.join(',')}"
          redirect_back(fallback_location: admin_employees_path)
        end
      }
    end
    def check_for_action
      if params[:action_type] == "Approve"
        @ot_to_approve = Overtime.find(params[:overtime_id].to_i)
        @ot_to_approve.update_attributes(approval_status: "Approved", approved_by: current_system_user.name)
        flash[:error] = "Overtime has been Approved"
      elsif params[:action_type] == "Reject"
        @ot_to_reject = Overtime.find(params[:overtime_id].to_i)
        @ot_to_reject.update_attributes(approval_status: "Rejected", approved_by: current_system_user.name)
        flash[:error] = "Overtime has been Rejected"
      end
    end

    def render(*args)
      check_for_action
      super
    end
  end

  index :title => 'Overtime Approvals' do
    selectable_column
    column :employee
    column :number_of_hours
    column :date
    column :approval_status
    column 'Approve' do |i|
      link_to "Approve", admin_overtimes_path({ overtime_id: i.id, action_type: "Approve" })
    end
    column 'Reject' do |i|
      link_to "Reject", admin_overtimes_path({ overtime_id: i.id, action_type: "Reject" })
    end
  end

  show do
    attributes_table do
      row :number_of_hours
      row :employee
      row :date
      row :reason
      row :approval_status
      row :approved_by
    end
  end

  form  do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Overtime Details' do
      f.input :number_of_hours
      if params[:id].nil?
        f.input :employee_id, as: :select, :collection => Employee.all, include_blank: false, :input_html => { :id => "emp_id" }
      else
        f.input :employee_id, as: :select, :collection => Employee.where(id: params[:id].to_i), selected: params[:id].to_i, include_blank: false, :input_html => { :id => "emp_id" }
      end
      f.input :date, as: :date_picker
      f.input :reason
    end
    f.actions
  end
end