class CarMake < ApplicationRecord
  scope :categorized, lambda {
    select('car_makes.*, car_categories.name AS category_name')
      .joins(:car_category)
      .group_by(&:category_name)
  }

  has_many :car_models, dependent: :destroy
  belongs_to :car_category

  validates :car_category_id, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :car_category_id }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at] # Adjust this list according to your needs
  end

  def self.ransackable_associations(auth_object = nil)
    %w[car_category car_models]
  end
end
