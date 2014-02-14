class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :comments
  has_many :votes, dependent: :destroy

  after_create :create_vote

  default_scope order('created_at DESC')

  validates :body,
            :presence => {:message => "Can't be blank"},
            :length => {:minimum => 20, :message => "Must be more than 20 characters"}

  validates :title,
            :presence => {:message => "Can't be blank"},
            :length => {:minimum => 10, :message => "Must be more than 20 characters"}
  
  validates :urllink,
            :presence => {:message => "Can't be blank"}

  def points
    self.votes.sum(:value).to_i
  end

  def create_vote
    self.user.votes.create(value: 1, post: self)
  end 

  def should_generate_new_friendly_id?
    new_record?
  end

  def noralize_friendly_id(string)
    suerp[0..100]
  end
end


