class Shop < ApplicationRecord
  include Locationable
  include Categoriable

  mount_uploader :avatar_url, ImageUploader

  # Scopes
  scope :approved, -> { where(approved: true) }
  scope :by_rating, -> { order(average_rating: :desc) }

  # Associations
  has_many :accounts, as: :accountable, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :promo_codes, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :ratings, through: :offers, dependent: :destroy
  has_many :service_requests, through: :offers

  # Validations
  validates :name, :hours_of_operation, :techs_per_shift, :categories,
            :owner_name, :phone, :location, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :certified, inclusion: { in: [true, false] }, if: :mechanic_shop?
  validates :supervisor_permanently, :vehicle_warranties, :lounge_area,
            :complimentary_inspection, inclusion: { in: [true, false] }
  validates :techs_per_shift, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }
  validates :address, uniqueness: { case_sensitive: false }, if: -> { address.present? }
  validate :pictures_min_number
  validate :categories_values

  # Delegates
  delegate :email, to: :account, allow_nil: true

  # Constants
  CATEGORIES = {
    mechanic_shop: 0,
    car_wash: 1,
    perfomance_shop: 2,
    tire_shop: 3,
    # Add other categories here
  }.freeze

  accepts_nested_attributes_for :pictures, allow_destroy: true, reject_if: :blank?

  # Dynamic methods for each category
  CATEGORIES.keys.each do |category|
    define_method("#{category}?") do
      categories.is_a?(Array) && categories.include?(CATEGORIES[category])
    end
  end

  # Method to return avatar URL 
  def avatar_url
    avatar.present? ? avatar.url : ""
  end

  private

  def pictures_min_number
    errors.add(:pictures, :not_enough) if pictures.size < 3
  end

  def categories_values
    return if categories.is_a?(Array) && categories.all? { |c| CATEGORIES.value?(c) }

    errors.add :categories, :invalid
  end

  def remove_categories_duplications
    self.categories = categories.uniq if categories.is_a?(Array)
  end

  # Ransackable attributes for search
  def self.ransackable_attributes(auth_object = nil)
    ["additional_info", "address", "approved", "avatar_url", "average_rating", "categories", "certified", "complimentary_inspection", 
     "created_at", "hours_of_operation", "id", "languages", "location", "lounge_area", "name", "owner_name", "phone", 
     "supervisor_permanently", "techs_per_shift", "tow_track", "updated_at", "vehicle_diesel", "vehicle_electric", 
     "vehicle_warranties"]
  end
end
