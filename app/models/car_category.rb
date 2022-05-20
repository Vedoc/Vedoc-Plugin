class CarCategory < ApplicationRecord
  has_many :car_makes, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
