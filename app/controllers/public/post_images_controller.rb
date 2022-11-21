class Public::PostImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    if params[:post_image][:tag_name].present?
      tag_list = params[:post_image][:tag_name].split(nil)
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
    @post_images = PostImage.all
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
  end

  def update
    if @post_image.update(post_image_params)
      redirect_to post_image_path(@post_image)
    else
      render "edit"
    end
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end


  private

  def post_image_params
    params.require(:post_image).permit(:title, :image, :caption, :address)
  end

  def ensure_correct_user
    @post_image = PostImage.find(params[:id])
    unless @post_image.user == current_user
      redirect_to post_images_path
    end
  end

end
