class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, only: [:show, :update, :edit, :destroy]
  def new
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate page: params[:page],
      per_page: Settings.users.users_per_page
  end

  def show
    redirect_to root_path and return unless @user.activated?
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.users.posts_per_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.please_check_email"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flash.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user && @user.destroy
      flash[:success] = t "index_page.successfully_deleted"
      redirect_to users_path
    else
      flash[:danger] = t "index_page.delete_failed"
      redirect_to users_path
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    @user || render(file: "public/404.html", status: 404, layout: true)
  end
end
