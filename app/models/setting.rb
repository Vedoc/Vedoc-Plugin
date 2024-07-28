# app/models/setting.rb
class Setting < ApplicationRecord
  validates :var, presence: true, uniqueness: { scope: [:thing_type, :thing_id] }
  validates :value, presence: true, unless: -> { value.nil? }

  def self.password_reset_duration
    find_by(var: 'password_reset_duration').value.to_i
  end

  def self.method_missing(method, *args)
    setting = find_by(var: method.to_s)
    setting ? setting.value : super
  end

  def self.respond_to_missing?(method, include_private = false)
    exists?(var: method.to_s) || super
  end
end
