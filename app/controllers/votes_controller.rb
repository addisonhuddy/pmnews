class VotesController < ApplicationController
  before_filter :setup
  
  def add_point
    update_vote(1)
    redirect_to :back
  end


private

  def setup
    authorize! :create, Vote, message: "You need to be a user to do that."
    @post = Post.friendly.find(params[:post_id])
    @vote = @post.votes.where(user_id: current_user.id).first
  end

  def update_vote(new_value)
    if @vote # if it exists, update it
      @vote.update_attribute(:value, new_value)
    else # create it
      @vote = current_user.votes.create(value: new_value, post: @post)
    end
  end

end
