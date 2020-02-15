class SystemUser < ApplicationRecord
  belongs_to :employee
  devise :database_authenticatable, :authentication_keys => [:user_name]

  validates :user_name, presence: true, uniqueness: true

  def name
    employee.full_name
  end
end