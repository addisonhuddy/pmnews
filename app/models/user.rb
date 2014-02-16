class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes, dependent: :destroy

  before_create :set_member

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:twitter]

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      pass = Devise.friendly_token[0,20]
      user = User.new(provider: auth.provider,
                      uid: auth.uid,
                      username: auth.info.nickname,
                      password: pass,
                      password_confirmation: pass,
                      email: '#{auth.info.nickname}@twitter.com'
                    )
      user.skip_confirmation!
      user.save
    end
    user
  end

  private

  def set_member
    self.role = 'member'
  end

end