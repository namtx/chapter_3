class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:sessions][:email].downcase
    if user && user.authenticate(params[:sessions][:password])
      if user.activated?
        login user
        params[:sessions][:remember_me] == Settings.login.remember_me ? remember(user): forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "flash.warning_account_activation"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "login_page.invalid_email_password"
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end
end
