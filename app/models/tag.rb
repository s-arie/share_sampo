class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy
  has_many :post_images, through: :tag_relationships

  validates :tag_name, length: { minimum: 2, maximum: 20 }

  def self.search_for(content, method)
    if method == 'perfect'
      Tag.where(tag_name: content)
    elsif method == 'forward'
      Tag.where('tag_name LIKE ?', content+'%')
    elsif method == 'backward'
      Tag.where('tag_name LIKE ?', '%'+content)
    else
      Tag.where('tag_name LIKE ?', '%'+content+'%')
    end
  end

end
