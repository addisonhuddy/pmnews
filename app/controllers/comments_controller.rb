class CommentsController < ApplicationController
  
  respond_to :html, :xml, :js

  def new
    @post =Post.friendly.find(params[:post_id])
    @comment = Comment.new(:parent_id => params[:parent_id])
  end

  def show
    @post = Post.friendly.find(params[:post_id])
    @postcomments = Comment.find(params[:parent_id])
    @comment = Comment.new(:parent_id => params[:parent_id])
  end

  def create
    @post = Post.friendly.find(params[:post_id])
    @comments = @post.comments
    @comment = Comment.new(comment_params)
    @comment.post = @post

    authorize! :create, Comment, message: "You need to be signed up to do that."
    
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
      end
    else
      flash[:error] = 'There was an error saving the comment. Please try again.'
      render 'posts/show'
    end
  end

  def update
  end

  def destroy
  end

  def edit
  end

private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id, :parent_id)
  end

end
