class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes, dependent: :destroy
  
  before_create :set_member

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:twitter], :authentication_keys => [:login]

  validates :username,
    :uniqueness => {
      :case_sensitive => false }
  
  ROLES = %w[member admin]

  def role?(base_role)
    role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
  
  def admin?
    role == "admin"
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      pass = Devise.friendly_token[0,20]
      user = User.new(provider: auth.provider,
                      uid: auth.uid,
                      username: auth.info.nickname,
                      password: pass,
                      password_confirmation: pass,
                      email: pass
                    )
      user.skip_confirmation!
      user.save
    end
    user
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

  def remember_me
    true
  end

  private

  def set_member
    unless admin?
      self.role = 'member'
    end
  end

end