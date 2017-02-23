class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @micropost_quantity = current_user.microposts.size
      @feed_items = current_user.feed.paginate page: params[:page],
        per_page: Settings.home.feeds_per_page
      @user ||= current_user
      @following_quantity = @user.following.size
      @followers_quantity = @user.followers.size
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
