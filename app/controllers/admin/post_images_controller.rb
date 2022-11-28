class Admin::PostImagesController < ApplicationController

  def index
    @post_images = PostImage.all
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
    @tag_relationships = @post_image.tags
  end

  def destroy
    @post_image = PostImage.find(params[:id])

    @post_image.destroy
    redirect_to admin_post_images_path
  end


  private

  def post_image_params
    params.require(:post_image).permit(:title, :image, :caption, :address)
  end

end
