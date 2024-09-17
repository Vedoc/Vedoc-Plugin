# app/models/setting.rb
class Setting < ApplicationRecord
  validates :var, presence: true, uniqueness: { scope: [:thing_type, :thing_id] }
  validates :value, presence: true, unless: -> { value.nil? }

  # Example of a custom method that retrieves specific setting values
  def self.password_reset_duration
    find_by(var: 'password_reset_duration').value.to_i
  end

  # Modify method_missing to handle defaults
  def self.method_missing(method, *args)
    setting = find_by(var: method.to_s)
    return setting.value if setting.present?

    # If a default value is passed as an argument, use it
    default_value = args.first if args.present?
    return default_value if default_value

    # If no default, raise an error as before
    super
  end

  def self.respond_to_missing?(method, include_private = false)
    exists?(var: method.to_s) || super
  end
end

