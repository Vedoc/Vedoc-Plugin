class Vehicle < ApplicationRecord
  mount_uploader :photo, ImageUploader

  # Associations
  belongs_to :client
  has_many :service_requests, dependent: :destroy

  # Validations
  validates :make, :model, :year, :category, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  # Ensure category is never null in the database
  before_validation :normalize_category
  
  # Scopes
  scope :ordered, -> { order(created_at: :desc) }
  scope :with_client, -> { includes(:client) }

  def self.ransackable_associations(auth_object = nil)
    ["client", "service_requests"]
  end

  private

  def normalize_category
    self.category = category.presence || ''
  end
end