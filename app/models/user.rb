class User < ActiveRecord::Base
  include LookupHelper

  custom_slug :name, case_insensitive: true
  has_secure_password
  attr_accessor  :activation_token, :reset_token
  has_one :card
  has_many :order_forms
  belongs_to :upload, foreign_key: :avatar 

  def User.lead_paths
    Rails.application.routes.routes.collect {|r| r.path.spec.to_s }.collect {|path| if (match = /^\/([^\/\(:]+)/.match(path)); match[1]; else; ""; end;}.compact.uniq.push("-1", "-2")
  end

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }, exclusion: { in: User.lead_paths }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  validates :password, length: { minimum: 6 }, allow_blank: true

  def avatar
    lookup_for(user: id, image: "?").child_id
  end

  def pools
    children(user: id, pool: "?")
  end

  def messages
    @messages ||= Message.where("user_id = ? AND ? = ANY (recipient_ids)", -1, id)
  end

  def pms
    @pms ||= Message.where("submission_id IS NULL AND user_id > 0 AND (user_id = ? OR ? = ANY (recipient_ids))", id, id)
  end

  def watched_by
    User.where("? = ANY (watching)", id)
  end

  def self.level_for(grade)
    CONFIG[:user_levels].index(grade.to_s)
  end

  def send_activation_email
    update_attribute(:activation_digest, create_activation_digest)
    UserMailer.account_activation(self).deliver_now
  end

  def at_level(grade)
    User.level_for(level) == User.level_for(grade)
  end

  def at_least(grade)
    User.level_for(level) >= User.level_for(grade)
  end

  def self.search(terms)
    begin
      terms[:tags] ||= ""
      tags = terms[:tags].split(" ").map { |tag| tag.strip.delete(",") }.join("&")
      statuses = terms[:statuses].reject { |key, value| terms[:use_statuses][key] == "0" }.map { |key, value| [terms[:statuses].keys.index(key) + 1, value] }
      result = /^\s*$/.match(tags)? User.all : User.where("tags_tsvector @@ #{sanitize_sql_array(["to_tsquery('english', ?)", tags])}")
      statuses.each do |pair|
        pair[1] = CONFIG[:status_categories][Regexp.new("(#{CONFIG[:status_categories].keys.join("|")})").match(pair[1])[0].to_sym].map { |status| status.to_s }.join(",") rescue pair[1]
        result = result.where("statuses[?] = ANY (string_to_array(?, ','))", pair[0], pair[1])
      end
      result
    rescue
      ActiveRecord::Relation.new
    end
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
