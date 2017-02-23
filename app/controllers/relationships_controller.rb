class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_followed_user, only: :create
  before_action :load_following_user, only: :destroy
  def create
    current_user.follow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  private
  def load_followed_user
    @user = User.find_by id: params[:followed_id]
    unless @user
      flash[:danger] = t "flash.follow_error"
      redirect_to root_path
    end
  end

  def load_following_user
    relationship = Relationship.find_by id: params[:id]
    if relationship
      @user = relationship.followed
      return @user if @user
    end
    flash[:danger] = t "flash.unfollow_error"
    redirect_to root_path
  end
end
