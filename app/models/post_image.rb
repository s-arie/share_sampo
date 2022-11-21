class PostImage < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships
  accepts_nested_attributes_for :tags

  # モデルの中で、オブジェクトの住所がどこにあるかをgeocoderに伝える
  geocoded_by :address
  # addressカラムに入った情報を元に「latitude」「longitude」に緯度・経度の情報が入る
  after_validation :geocode


  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/default-image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      PostImage.where(title: content)
    elsif method == 'forward'
      PostImage.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      PostImage.where('title LIKE ?', '%'+content)
    else
      PostImage.where('title LIKE ?', '%'+content+'%')
    end
  end

  def save_tag(tag_list)
    if self.tags != nil
      post_image_tags_records = TagRelationship.where(post_image_id: self.id)
      post_image_tags_records.destroy_all
    end

    tag_list.each do |tag|
      inspected_tag = Tag.where(tag_name: tag).first_or_create
      self.tags << inspected_tag
    end
  end
end
