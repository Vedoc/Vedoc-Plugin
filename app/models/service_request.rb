class ServiceRequest < ApplicationRecord
  include Locationable
  include Categoriable

  scope :pending, -> { where status: :pending }
  scope :in_repair, -> { where status: :in_repair }
  scope :done, -> { where status: :done }

  enum category: Shop::CATEGORIES
  enum status: %i[pending in_repair done]

  belongs_to :vehicle
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :offers, dependent: :destroy

  delegate :client, to: :vehicle, allow_nil: true

  accepts_nested_attributes_for :pictures, allow_destroy: true, reject_if: :blank?

  validates :summary, :location, :category, :title, :status, presence: true
  validates :evacuation, :repair_parts, inclusion: { in: [ true, false ] }
  validates :estimated_budget, numericality: { greater_than_or_equal_to: 0 },
                               if: -> { estimated_budget.present? }

                               def self.ransackable_associations(auth_object = nil)
                                %w[vehicle pictures offers] # Add associations you want to be searchable
                              end                            
end
