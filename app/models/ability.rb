class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    # if a member, they can manage their own posts 
    # (or create new ones)
    if user.role? :member
      can :manage, Post, :user_id => user.id
      can :manage, Comment, :user_id => user.id
      can :create, Vote
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all
    end

    can :read, Post
    can :read, Comment
    can :read, Vote

  end
end