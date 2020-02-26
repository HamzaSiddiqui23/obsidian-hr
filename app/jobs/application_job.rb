class ApplicationJob < ActiveJob::Base
  around_perform :around_cleanup

  after_enqueue do |job|
    Employee.first.update_attributes(first_name:"gaga")
 end

  def perform(*args)
    # Do something later
    puts args
  end
  private
  def around_cleanup
    AppMailer.payroll_complete(Employee.first).deliver_later
    Employee.first.update_attributes(first_name:"lulu")
    yield
    AppMailer.payroll_complete(Employee.first).deliver_later
    Employee.first.update_attributes(first_name:"success")
  end
end