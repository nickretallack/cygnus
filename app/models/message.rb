class Message < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  #after_create :notify_added
  
  validates :content, format: { with: /\S+/, message: "was empty!" }

  def pm_author
    parents("user", "message").first
  end

  def pms

  end

  def comment_author
    parents("user", "comment").first
  end

  def comments
    children("message", "comment")
  end

  def timestamp(type = :created)
    case type
    when :created
      created_at.strftime("%A %B %e, %Y at %l:%M%P %Z").gsub("  ", " ")
    when :modified
      modified_at.strftime("%A %B %e, %Y at %l:%M%P %Z").gsub("  ", " ")
    end
  end

  def Message.on_change #sse
    Message.connection.execute "LISTEN messages"
    loop do
      Message.connection.raw_connection.wait_for_notify do |event, pid, message|
        yield message
      end
    end
  ensure
    Message.connection.execute "UNLISTEN messages"
  end

  private

  def notify_added #sse
    Message.connection.execute "NOTIFY messages, '#{self.id}'"
  end
end
