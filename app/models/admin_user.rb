class AdminUser < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  # Define ransackable attributes for Ransack search
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at email id remember_created_at reset_password_sent_at updated_at]
  end
end
