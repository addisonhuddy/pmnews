class PostsController < ApplicationController
  
  respond_to :html, :xml, :js

  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      respond_to do |format|
        format.html { redirect_to @post }
      end
    else
      @post = Post.new
      flash[:error] = "There was an error saving your post."
      redirect_to new_post_path
    end
  end

  def update
  end

  def destroy
  end

private

  def post_params
    params.require(:post).permit(:title, :body, :urllink)
  end
end
