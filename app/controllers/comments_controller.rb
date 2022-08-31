class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_micropost
  before_action :set_current_user

  def new
    @comment = Comment.new
    @parent = Comment.find_by(id: params[:parent_id])
  end

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "comment has been created"
    else
      flash[:alert] = "comment has not been created"
    end
    redirect_to micropost_path(@micropost)
  end

  def destroy
    @comment = @micropost.comments.find(params[:id])
    @comment.destroy
    redirect_to micropost_path(@micropost)
  end

  def set_micropost
    @micropost = Micropost.find(params[:micropost_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id, :user_id, :micropost_id)
  end

  def set_current_user
    @current_user = current_user
  end
end
