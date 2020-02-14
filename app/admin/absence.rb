ActiveAdmin.register Absence do
  menu false
  permit_params :quantity, :employee_id, :date, :comment, :is_paid

  controller do
    def create
      create! { |success, failure|
        success.html { redirect_to admin_employee_path(resource.employee_id), :notice => "Absence has been added" }
        failure.html do
          flash[:error] = "Error : #{resource.errors.full_messages.join(',')}"
          redirect_back(fallback_location: admin_employees_path)
        end
      }
    end
  end

  form  do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Absence Details' do
      f.input :quantity, as: :select, collection: AppConstant::LEAVE_QUANTITY, include_blank: false
      if params[:id].nil?
        f.input :employee_id, as: :select, :collection => Employee.all, include_blank: false, :input_html => { :id => "emp_id" }
      else
        f.input :employee_id, as: :select, :collection => Employee.where(id: params[:id].to_i), selected: params[:id].to_i, include_blank: false, :input_html => { :id => "emp_id" }
      end
      f.input :date, as: :date_picker
      f.input :comment
      f.input :is_paid
    end
    f.actions
  end

end