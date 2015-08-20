class User < ActiveRecord::Base
  custom_slug :name
  scope :ci_find, lambda { |attribute, value| where("lower(#{attribute}) = ?", value.downcase).first }
  attr_accessor  :activation_token, :reset_token
  has_many :galleries, class_name: :Pool, dependent: :destroy
  has_many :kanban_lists
  belongs_to :upload, foreign_key: :avatar
  before_create :create_activation_digest
 

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }, exclusion: { in: :named_routes }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
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
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)",
	terms.gsub(/\s/,"+")])
    User.where("tags @@ #{sanitized}")
  end

  CONFIG[:user_levels].each do |name, value|
      normalized_name = name.downcase.gsub(/ /, "_")
      define_method("is_#{normalized_name}?") do
        self.level == value
      end

      define_method("is_#{normalized_name}_or_higher?") do
        self.level >= value
      end

      define_method("is_#{normalized_name}_or_lower?") do
        self.level <= value
      end
  end
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
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
    reset_sent_at < 2.hours.ago
  end

private
  def create_activation_digest  
      self.activation_token  = SecureRandom.urlsafe_base64
      self.activation_digest = User.digest(activation_token)
  end
end
