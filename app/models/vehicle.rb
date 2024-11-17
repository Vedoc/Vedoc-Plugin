class Vehicle < ApplicationRecord
  mount_uploader :photo, ImageUploader

  has_many :service_requests, dependent: :destroy
  belongs_to :client, optional: true

  validates :make, :model, :year, :category, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Skip validation for the client association in test and development environments
  validates :client, presence: true, unless: -> { Rails.env.development? || Rails.env.production? }

  def self.ransackable_associations(auth_object = nil)
    ["client", "service_requests"]
  end
end
