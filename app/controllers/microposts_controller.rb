class MicropostsController < ApplicationController
  load_and_authorize_resource :micropost
  load_and_authorize_resource :comment

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referer.nil? || request.referer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referer
    end
  end

  def like
    @micropost = Micropost.find(params[:id])
    if current_user.voted_up_on? @micropost
      @micropost.downvote_by current_user
    elsif current_user.voted_down_on? @micropost
      @micropost.upvote_by current_user
    else #not voted
      @micropost.upvote_by current_user
    end
    respond_to do |format|
      format.js
    end
  end

  def upvote
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    respond_to do |format|
      format.js
    end
  end

  def downvote
    @post = Post.find(params[:id])
    @post.downvote_by current_user
    respond_to do |format|
      format.js
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
