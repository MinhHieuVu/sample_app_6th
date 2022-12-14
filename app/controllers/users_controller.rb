class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.accessible_by(current_ability).paginate(page: params[:page])
    date_present = DateTime.now
    date_past = date_present - 1.month
    @microposts = current_user.microposts.where(created_at: date_past..date_present)
    @following_users = current_user.active_relationships.where(created_at: date_past..date_present)
    @followed_users = current_user.passive_relationships.where(created_at: date_past..date_present)
    micropost_csv = ExportCsvService.new(@microposts, Micropost::CSV_ATTRIBUTES, "microposts.csv")
    following_csv = ExportCsvService.new(@following_users, Relationship::CSV_ATTRIBUTES, "following_users.csv", :followed)
    follower_csv = ExportCsvService.new(@followed_users, Relationship::CSV_ATTRIBUTES, "follower_users.csv", :follower)
    respond_to do |format|
      format.zip { send_data ZipService.zip(micropost_csv, following_csv, follower_csv), filename: "export_csv.zip" }
    end
  end

  def show
    # @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    # @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    # User.find(params[:id]).destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    # @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    # @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  def chat
    @microposts = @user.microposts.paginate(page: params[:page])
    @room_name = get_name(@user, current_user)
    @single_room =
      Room.find_by(name: @room_name) || Room.create_private_room([@user, @current_user], @room_name)
    @messages = @single_room.messages

    render 'users/show'
  end

  private

  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    # @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
