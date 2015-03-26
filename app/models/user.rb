class User < ActiveRecord::Base
 before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true



  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)",
	terms.gsub(/\s/,"+")])
    User.where("tags_tsvector @@ #{sanitized}")
  end

  def is_anonymous?
	false
  end

  CONFIG["user_levels"].each do |name, value|
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
end
