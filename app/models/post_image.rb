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


  validates :title,presence:true
  # validates :image, attached_file_presence: true
  validates :caption,presence:true,length:{maximum:200}

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
    # 既にタグあるなら全取得
    current_tags = self.tags.present? ? self.tags.pluck(:tag_name) : []
    # 共通要素取り出し
    old_tags = current_tags - tag_list
    new_tags = tag_list - current_tags

    # 古いタグ削除
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    # 新しいタグ作成
    new_tags.each do |new|
      new_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_tag
    end
  end
end