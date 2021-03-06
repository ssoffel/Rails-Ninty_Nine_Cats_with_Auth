class User < ApplicationRecord
  validates :username, presence: true
  validates :password_digest, presence: { message: "Password can\'t be blank" }
  validates :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  has_many :cats,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: 'Cat'

  has_many :cat_requests

  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return user if user && BCrypt::Password.new(user.password_digest).is_password?(password)
    nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

 def password=(password)
   @password = password
   self.password_digest = BCrypt::Password.create(password)
 end

 def is_password(password)
   BCrypt::Password.new(self.password_digest).is_password?(password)
 end


  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end


end
