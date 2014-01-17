class UsersController < ApplicationController
  before_action :set_user, only: [:show,:edit,:update]
  before_action :require_user, except: [:show,:new,:create]
  before_action :require_creator, only: [:edit,:update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'You are registered.'
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Your profile was updated.'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:username,:password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_creator
    unless current_user.id == @user.id
      flash[:error] = "You're not allowed to do that."
      redirect_to root_path
    end
  end
end
