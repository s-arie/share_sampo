class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy
  has_many :post_images, through: :tag_relationships
end
