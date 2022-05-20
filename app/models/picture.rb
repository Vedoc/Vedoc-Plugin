class Picture < ApplicationRecord
  default_scope -> { order created_at: :asc }

  mount_uploader :data, ImageUploader

  belongs_to :imageable, polymorphic: true

  validates :imageable, :data, presence: true
end
