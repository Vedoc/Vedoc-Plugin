class ModelYear < ApplicationRecord
  belongs_to :car_model

  validates :car_model_id, presence: true
  validates :year, presence: true, uniqueness: { case_sensitive: false, scope: :car_model_id }
end
