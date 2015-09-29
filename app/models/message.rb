class Message < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  #after_create :notify_added
  
  validates :content, format: { with: /\S+/, message: "must have some content." }
  validate do
    if message_id
      message = Message.find(message_id)
      if message.nil?
        errors.add(:message_id, "##{message_id} does not exist.")
      elsif not submission_id == message.submission_id
        errors.add(:message_id, "##{message_id} is in another castle.")
      end
    end
  end

  def replies
    self.class.where(message_id: id)
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
