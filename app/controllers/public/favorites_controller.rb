class Public::FavoritesController < ApplicationController

  def create
    post_image = PostImage.find(params[:post_image_id])
    favorite = Favorite.new(post_image_id: post_image.id)
    favorite.user_id = current_user.id
    favorite.save
    redirect_to post_image_path(post_image)
  end

  def destroy
    post_image = PostImage.find(params[:post_image_id])
    favorite = Favorite.find_by(post_image_id: post_image.id)
    favorite.user_id = current_user.id
    favorite.destroy
    redirect_to post_image_path(post_image)
  end

end
