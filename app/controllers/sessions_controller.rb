class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, you've logged in."
      redirect_to root_path
    else
      flash[:error] = 'There is something wrong with your username or password.'
      redirect_to login_path
    end
  end

  def destroy
    flash[:notice] = "You've logged out."
    session[:user_id] = nil
    redirect_to root_path
  end
end
