class AppMailer < ApplicationMailer
  default  from: 'a@example.com'

  def payroll_complete(user)
    @user  = user
    mail(to: @user.email, subject: "Payroll has been processed")
  end
end