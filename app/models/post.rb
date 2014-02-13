class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :comments
  has_many :votes, dependent: :destroy

  after_create :create_vote

  def points
    self.votes.sum(:value).to_i
  end

  def create_vote
    self.user.votes.create(value: 1, post: self)
  end 

  def should_generate_new_friendly_id?
    new_record?
  end

end


