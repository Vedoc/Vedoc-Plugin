class Rating < ApplicationRecord
  before_create :update_average_rating

  belongs_to :offer
  belongs_to :client

  validates :offer, :score, presence: true
  validates :score, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
  validates :offer_id, uniqueness: true

  private

  # rubocop:disable Rails/SkipsModelValidations
  def update_average_rating
    ratings = offer.shop.ratings.pluck( :score ) << score
    new_average = ratings.sum.fdiv ratings.size

    offer.shop.update_attribute :average_rating, new_average
  end
  # rubocop:enable Rails/SkipsModelValidations
end
