class Public::PostCommentsController < ApplicationController
  def create
    post_image = PostImage.find(params[:post_image_id])
    @comment = PostComment.new(post_comment_params)
    @comment.user_id = current_user.id
    @comment.post_image_id = post_image.id
    @comment.save
  end

  def destroy
    @comment = PostComment.find(params[:id])
    @comment.destroy
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
