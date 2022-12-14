class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
  scope :all_except, ->(user) {where.not(id: user)} #search all users except current user
  after_create_commit {broadcast_append_to "users"}
  has_many :messages, dependent: :destroy
  acts_as_voter
  has_many :emotes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
else
  BCrypt::Engine.cost
end
    BCrypt::Password.create(string, cost: cost)
  end

  # begin login gg facebook
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable,
  #        :omniauthable , omniauth_providers: [:facebook, :google_oauth2]

  def self.from_omniauth(auth)
    result = User.find_or_create_by(email: auth.info.email)
    result.name = auth.info.name if result.name.nil?
    result.email = auth.info.email
    result.activated = true
    result.password = SecureRandom.urlsafe_base64 if result.password.nil?
    result.save!
    result.providers.find_or_create_by(provider: auth.provider, name: auth.info.name)
    result
  end
  # end login gg facebook

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a user's status feed.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow other_user
    following << other_user unless self == other_user
  end

  # Unfollows a user.
  def unfollow other_user
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following? other_user
    following.include?(other_user)
  end

  private

  # Converts email to all lowercase.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
