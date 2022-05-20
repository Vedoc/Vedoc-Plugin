class CarModel < ApplicationRecord
  belongs_to :car_make
  has_many :model_years, dependent: :destroy

  validates :car_make_id, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :car_make_id }
end
