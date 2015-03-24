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
end