ActiveAdmin.register SystemUser do
  menu false
  permit_params :user_name, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :user_name
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :user_name
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user_name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
