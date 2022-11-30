class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  include CommentsHelper
  load_and_authorize_resource :micropost

  def create
    @like = current_user.likes.new(like_params)
    # @micropost = Micropost.find(params[:id])
    flash[:notice] = @like.errors.full_messages.to_sentence unless @like.save
    redirect_to root_url if @micropost.nil?


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
