class CommentsController < ApplicationController
  
  respond_to :html, :xml, :js

  def create
    @post =Post.friendly.find(params[:post_id])
    @comments = @post.comments
    @comment = Comment.new(comment_params)
    @comment.post = @post

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
      end
    else
      flash[:error] = 'There was an error saving the comment. Please try again.'
      render 'post/show'
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
    params.require(:comment).permit(:body, :post_id, :user_id)
  end

end
