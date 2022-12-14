class Public::PostImagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    tag_list = []
    if params[:post_image][:tag_name].present?
      tag_list = params[:post_image][:tag_name].split(/\s*,\s*/)
    end
    if @post_image.save
      @post_image.save_tag(tag_list)
      redirect_to post_images_path
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def index
    @post_images = params[:tag_id].present? ? Tag.find(params[:tag_id]).post_images : PostImage.all
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
    @tag_relationships = @post_image.tags
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end


  private

  def post_image_params
    params.require(:post_image).permit(:title, :image, :caption, :address, tags_attributes: [:id, :tag_name])
  end

  def ensure_correct_user
    @post_image = PostImage.find(params[:id])
    unless @post_image.user == current_user
      redirect_to post_images_path
    end
  end

end
