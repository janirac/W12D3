class User < ApplicationRecord
  has_secure_password

  before_validation :ensure_session_token

  validates :username, 
    uniqueness: true, 
    length: { in: 3..30 }, 
    format: { without: URI::MailTo::EMAIL_REGEXP, message:  "can't be an email" }
  validates :email, 
    uniqueness: true, 
    length: { in: 3..255 }, 
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { in: 6..255 }, allow_nil: true

  def self.find_by_credentials(credentials, password)

    if URI::MailTo::EMAIL_REGEXP.match?(credentials)
      user = User.find_by(email: credentials)
    else
      user = User.find_by(username: credentials)
    end 

    if user&.authenticate(password)
      return user
    else
      nil
    end 
  end 

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end 
  
  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end 
  
  private
  def generate_unique_session_token
    while true
      token = SecureRandom::urlsafe_base64
      return token unless User.exists?(session_token: token)
    end 
  end 
end
