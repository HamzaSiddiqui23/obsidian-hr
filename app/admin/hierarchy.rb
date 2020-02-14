ActiveAdmin.register_page "Hierarchy" do
  menu false
  content do
      render :partial => 'hierarchy'
  end
  
  action_item :back do
    link_to "Go Back", admin_employee_path(params[:id])
  end

end