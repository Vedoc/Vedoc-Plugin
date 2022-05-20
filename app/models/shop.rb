class Shop < ApplicationRecord
  include Locationable
  include Categoriable

  mount_uploader :avatar, ImageUploader

  scope :approved, -> { where approved: true }
  scope :by_rating, -> { order( average_rating: :desc ) }

  has_many :accounts, as: :accountable, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :promo_codes, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :ratings, through: :offers, dependent: :destroy
  has_many :service_requests, through: :offers

  before_validation :remove_categories_duplications

  CATEGORIES = {
    mechanic_shop: 0,
    car_wash: 1,
    perfomance_shop: 2,
    tire_shop: 3,
    window_tint: 4,
    auto_customization: 5,
    car_stereo_installation: 6,
    boat_repair: 7,
    electric_vehicle_charging_station: 8,
    exhaust_shop: 9,
    auto_paint: 10,
    independent_mechanic: 11,
    auto_parts: 12,
    auto_glass_service: 13,
    windshield_service: 14,
    towing: 15,
    auto_upholstery: 16,
    vehicle_transportation: 17,
    pre_purchase_inspection: 18,
    motorcycle_repair: 19,
    vehicle_rental: 20,
    auto_locksmith: 21
  }.freeze

  accepts_nested_attributes_for :pictures, allow_destroy: true, reject_if: :blank?

  validates :name, :hours_of_operation, :techs_per_shift, :categories,
            :owner_name, :phone, :location, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :certified, inclusion: { in: [ true, false ] }, if: :mechanic_shop?
  validates :supervisor_permanently, :vehicle_warranties, :lounge_area,
            :complimentary_inspection, inclusion: { in: [ true, false ] }
  validates :techs_per_shift, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }
  validates :address, uniqueness: { case_sensitive: false }, if: -> { address.present? }
  validate :pictures_min_number
  validate :categories_values

  delegate :email, to: :account, allow_nil: true

  CATEGORIES.keys.each do | category |
    define_method( "#{ category }?" ) do
      categories.is_a?( Array ) && categories.include?( CATEGORIES[ category ] )
    end
  end

  private

  def pictures_min_number
    errors.add( :pictures, :not_enough ) if pictures.size < 3
  end

  def categories_values
    return if categories.is_a?( Array ) && categories.all? { | c | CATEGORIES.value?( c ) }

    errors.add :categories, :invalid
  end

  def remove_categories_duplications
    self.categories = categories.uniq if categories.is_a?( Array )
  end
end
