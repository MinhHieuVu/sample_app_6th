class MicropostsController < ApplicationController
  load_and_authorize_resource :micropost
  load_and_authorize_resource :comment

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    respond_to do |format|
      if @micropost.save
        format.html { redirect_to root_url, notice: "Micropost created!" }
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
        format.html { render "static_pages/home", status: :unprocessable_entity }
      end
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

  private

  def vote
    if current_user.liked? @micropost
      @micropost.unliked_by current_user
    else
      @micropost.liked_by current_user
    end
    respond_to do |format|
      format.js
    end
  end

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
