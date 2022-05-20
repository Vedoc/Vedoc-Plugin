class Device < ApplicationRecord
  belongs_to :account

  enum platform: %i[android ios]

  validates :platform, presence: true
  validates :device_id, presence: true, uniqueness: { scope: %i[platform account_id] }
  validates :device_token, uniqueness: { scope: :device_id }, if: -> { device_token.present? }
end
