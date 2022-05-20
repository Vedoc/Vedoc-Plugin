class Vehicle < ApplicationRecord
  mount_uploader :photo, ImageUploader

  has_many :service_requests, dependent: :destroy
  belongs_to :client

  validates :make, :model, :year, :category, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
