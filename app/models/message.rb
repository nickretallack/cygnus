class Message < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  after_create :notify_added
  
  validates :content, format: { with: /\S+/, message: "must have some content." }

  def replies
    self.class.where("message_id = ?", id)
  end

  def timestamp
    modified_at.strftime("%A %B %e, %Y at %l:%M%P %Z").gsub("  ", " ")
  end

  def Message.on_change
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

  def notify_added
    Message.connection.execute "NOTIFY messages, '#{self.id}'"
  end
end
