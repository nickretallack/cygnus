class User < ActiveRecord::Base
  include LookupHelper

  each_page_show 10
  custom_slug :name, case_insensitive: true
  has_secure_password
  attr_accessor  :activation_token, :reset_token

  validates :name, presence: true, length: { maximum: 50 }, 
    format: {with:/\A[-a-zA-Z0-9]\z/, 
    message: "can only contain alphanumeric characters and dashes"}, 
    uniqueness: { case_sensitive: false }, exclusion: { in: ["s", "assets"] }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
    format: { with: VALID_EMAIL_REGEX, message: "must be a valid email" }, 
    uniqueness: { case_sensitive: false }
  
  validates :password, length: { minimum: 6, maximum: 72 }
  def anon?
    false #needed for permissions control
  end
  
  def user?
    true
  end
  
  def avatar
    children("image", "avatar").first
  end

  def pools
    children("pool")
  end

  def gallery
    pools.first
  end

  def cards
    children("card").first
  end

  def card
    children("card").first
  end

  def order_forms
    children("order_form")
  end

  def order_form
    order_forms.first
  end

  def orders
    children("order")
  end

  def undecided_orders
    orders.where(decided: false)
  end

  def placed_orders
    children("order", "placed_order")
  end

  def unread_messages
    children("message", "unread_message")
  end

  def messages
    children("message")
  end

  def pms_sent
    children("message", "pm_sent")
  end

  def pms
    children("message", "pm")
  end

  def unread_pms
    children("message", "unread_pm")
  end

  def watched_by
    User.where("? = ANY (watching)", id)
  end

  def recent_submissions
    Submission.where("array_to_string(attachments, ',') ~ 'image'")
      .where(hidden: false).limit(5).order("id desc")
      .select{ |submission| submission.user == self}
  end

  def recent_favorite_submissions
    Submission.where("id = ANY('{#{favs.join(",")}}')")
  end

  def announcements
    children("message", "announcement")
  end

  def announcement
    announcements.last
  end

  def setting(key)
    setting = settings.fetch(key.to_s, false)
    setting == "1"? true : false
  end

  def self.level_for(grade)
    CONFIG[:user_levels].index(grade.to_s)
  end

  def at_level?(grade)
    User.level_for(level) == User.level_for(grade)
  end

  def at_least?(grade)
    User.level_for(level) >= User.level_for(grade)
  end

  def self.search(terms)
    begin
      terms["tags"] ||= ""
      tags = terms["tags"].split(",").map{ |tag| tag.strip }
      names = tags.select{ |tag| /^username:.+/i.match(tag) }
        .collect{ |tag| /^username:(.+)/i.match(tag)[1] }
      tags = tags.join("&").gsub(/\s+/, "&")
      statuses = terms["statuses"].reject { |key, value| terms["use_statuses"][key] == "0" }
        .map { |key, value| [terms["statuses"].keys.index(key) + 1, value] }
      unless names.empty?
        result = User.where("name ~* ANY('{#{names.join(",")}}')")
      else
        result = /^\s*$/.match(tags)? User.all : User.where("tags_tsvector @@ #{sanitize_sql_array(["to_tsquery('english', ?)", tags])}")
      end
      statuses.each do |pair|
        pair[1] = CONFIG[:status_categories][Regexp.new("(#{CONFIG[:status_categories].keys.join("|")})").match(pair[1])[0].to_sym].map{ |status| status.to_s }.join(",") rescue pair[1]
        result = result.where("statuses[?] = ANY (string_to_array(?, ','))", pair[0], pair[1])
      end
      result
    rescue
      User.none
    end
  end
  
  def User.digest(string)
    BCrypt::Password.create(string)
  end

  def authenticated?(token)
    if activation_digest
      BCrypt::Password.new(activation_digest).is_password?(token)
    else
      false
    end
  end

  def send_activation_email
    self.activation_token = SecureRandom.urlsafe_base64
    self.activation_digest = User.digest(self.activation_token)
    self.save
    UserMailer.activation(self).deliver_now
  end

  def send_reset_email  
    self.reset_token = SecureRandom.urlsafe_base64
    self.activation_digest = User.digest(self.reset_token)
    self.reset_sent_at = Time.zone.now
    self.save
    UserMailer.reset(self).deliver_now
  end

  def reset_expired?
    reset_sent_at < CONFIG[:password_reset_shelf_life].ago
  end

end
