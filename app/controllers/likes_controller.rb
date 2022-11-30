class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  include CommentsHelper
  load_and_authorize_resource :micropost

  def create
    @like = current_user.likes.new(like_params)
    flash[:notice] = @like.errors.full_messages.to_sentence unless @like.save

  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
  end

  private

  def like_params
    params.require(:like).permit(:micropost_id)
  end
end
