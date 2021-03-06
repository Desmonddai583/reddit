class PostsController < ApplicationController
  before_action :set_post, only: [:show,:edit,:update,:vote]
  before_action :require_user, except: [:index,:show]
  before_action :require_creator, only: [:edit,:update]

  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:notice] = 'Your post was created.'
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'The post was updated.'
      redirect_to posts_path
    else
      render :edit
    end
  end

  def vote
    vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    respond_to do |format|
      format.html do
       if vote.valid?
         flash[:notice] = 'Your vote was counted.'
       else
         flash[:error] = "You can only vote for <strong>#{@post.title}</strong> once.".html_safe
       end
       redirect_to :back
      end
      format.js do
        if vote.valid?
          flash.now[:notice] = 'Your vote was counted.'
        else
          flash.now[:error] = "You can only vote for <strong>#{@post.title}</strong> once.".html_safe
        end
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:url,:title,:description,category_ids: [])
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def require_creator
    unless current_user.id == @post.creator.id || current_user.admin?
      flash[:error] = "You're not allowed to do that."
      redirect_to root_path
    end
  end
end
