class Public::HomesController < ApplicationController
  def top
    post_image_ranking_ids = Favorite.select('post_image_id, count(id) as count').group('post_image_id').order('count DESC').limit(5).map {|favorite| favorite.post_image_id}
    @post_images = PostImage.find(post_image_ranking_ids)
  end

  def about
  end
end
