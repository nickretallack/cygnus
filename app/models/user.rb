class User < ActiveRecord::Base
  custom_slug :name, case_insensitive: true
  has_secure_password
  attr_accessor  :activation_token, :reset_token
  has_many :pools
  has_many :kanban_lists
  has_many :messages
  has_many :comments
  has_many :order_forms
  belongs_to :upload, foreign_key: :avatar
  before_create :create_activation_digest
 

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }, exclusion: { in: :named_routes }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  validates :password, length: { minimum: 6 }, allow_blank: true
  
  def named_routes
    Rails.application.routes.named_routes.helpers.map(&:to_s).collect{ |route| route.gsub(/_path|_url/, "") }
  end

  def self.level_for(grade)
    CONFIG[:user_levels].index(grade.to_s)
  end

  def at_level(grade)
    level == User.level_for(grade)
  end

  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/, "+")])
    User.where("tags_tsvector @@ #{sanitized}")
  end
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest  
    self.reset_token = SecureRandom.urlsafe_base64
    update_attribute(:activation_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < CONFIG[:password_reset_shelf_life].ago
  end

  private

  def create_activation_digest  
      self.activation_token  = SecureRandom.urlsafe_base64
      self.activation_digest = User.digest(activation_token)
  end
end
