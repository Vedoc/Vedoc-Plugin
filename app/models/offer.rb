class Offer < ApplicationRecord
  scope :not_accepted, -> { where accepted: false }
  scope :accepted_only, -> { where accepted: true }

  has_one :rating, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy

  belongs_to :service_request
  belongs_to :shop

  before_validation :set_default_offer
  before_save :check_state

  accepts_nested_attributes_for :pictures, allow_destroy: true, reject_if: :pictures_available

  validates :service_request, :shop, presence: true
  validates :accepted, inclusion: { in: [ true, false ] }
  validates :service_request_id, uniqueness: { scope: :shop_id }
  validates :budget, presence: true, numericality: { greater_than_or_equal_to: 0 }

  delegate :client, to: :service_request

  private

  # rubocop:disable Rails/SkipsModelValidations
  def check_state
    service_request.update_attribute( :status, :in_repair ) if accepted_changed? && accepted
  end
  # rubocop:enable Rails/SkipsModelValidations

  def set_default_offer
    self.budget = service_request&.estimated_budget unless budget
  end

  def pictures_available( attrs )
    attrs[ 'data' ].blank? || service_request.pending?
  end
end
