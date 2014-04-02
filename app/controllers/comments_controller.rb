class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.user_id = current_user.id

    if @comment.save
      flash[:notice] = 'Your comment was added.'
      redirect_to post_path(@post)
    else
      @post.reload
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)


    respond_to do |format|
      format.html do
        if vote.valid?
          flash[:notice] = 'Your vote was counted.'
        else
          flash[:error] = "You can only vote for this comment once."
        end

        redirect_to :back
      end
      format.js do
        if vote.valid?
          flash.now[:notice] = 'Your vote was counted.'
        else
          flash.now[:error] = "You can only vote for this comment once."
        end
      end
    end
  end
end
