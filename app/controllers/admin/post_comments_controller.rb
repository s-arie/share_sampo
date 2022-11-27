class Admin::PostCommentsController < ApplicationController

  def destroy
    @comment = PostComment.find(params[:id])
    @comment.destroy
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end