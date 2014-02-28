class PostsController < ApplicationController
  
  respond_to :html, :xml, :js

  def index
    @posts = Post.friendly.paginate(:page => params[:page], :per_page => 25)
  end

  def show
    @post = Post.friendly.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def new
    @post = Post.new
    authorize! :create, Post, message: "You need to be signed up to do that."
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    authorize! :create, Post, message: "You need to be signed up to do that."
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
    params.require(:post).permit(:title, :body, :urllink, :user_id)
  end
end
