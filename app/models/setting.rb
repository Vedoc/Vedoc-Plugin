# app/models/setting.rb
class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  def self.method_missing(method, *args)
    setting = find_by(key: method.to_s)
    setting ? setting.value : super
  end

  def self.respond_to_missing?(method, include_private = false)
    exists?(key: method.to_s) || super
  end
end
