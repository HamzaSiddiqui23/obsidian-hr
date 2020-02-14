ActiveAdmin.register_page "Payroll" do
  menu false
  content do
      render :partial => 'payroll'
  end

  action_item :print_reciept do
    link_to 'Print Reciept', '#', :onclick => 'window.print();'
  end

  action_item :back do
    link_to "Go Back", admin_employee_path(params[:id])
  end

end