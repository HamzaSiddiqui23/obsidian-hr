class AppMailer < ApplicationMailer
  default  from: 'a@example.com'

  def payroll_complete(user)
    @user  = user
    mail(to: @user.email, subject: "Payroll has been processed")
  end

  def approval_required(user, approval_type, approval_id)
    @manager = Employee.find(user.manager_id)
    @user = user
    @approval_type = approval_type
    @approval_id = approval_id
    if approval_type == 'leaves'
      @url = admin_leaves_url
    elsif approval_type == 'advances'
      @url = admin_advances_url
    else
      @url = admin_overtimes_url
    end
    mail(to: @manager.email, subject: "Request for Approval for #{approval_type} for #{user.full_name}")
  end

  def approval_status_update(user, approval_type, approval_date, approval_status)
    @user = user
    @approval_type = approval_type
    @approval_date = approval_date
    @approval_status = approval_status
    mail(to: @user.email, subject: "Request for Approval for #{approval_type} has been #{approval_status}")
  end
end