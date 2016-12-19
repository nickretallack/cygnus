class MessageMailer < ApplicationMailer
  def send_message(message)
    @message = message
    @user = message.recipient
    attachments.inline["logo.png"] = File.read(File.join(CONFIG[:image_path], CONFIG[:logo_email]))
    mail to: @user.email, 
         subject: "#{CONFIG[:name]}: You have a new message (#{message.attachments.first.titleize})"
  end

  def send_comment(card, user, data)
    @card = card
    @user = user
    @recipient = data[:recipient]
    @sender = data[:sender]
    attachments.inline["logo.png"] = File.read(File.join(CONFIG[:image_path], CONFIG[:logo_email]))
    mail to: @recipient[:email], 
         subject: "#{CONFIG[:name]}: You have a comment on a workboard submission!)"
  end

  def time_over(request)
    @message = request
    attachments.inline["logo.png"] = File.read(File.join(CONFIG[:image_path], CONFIG[:logo_email]))
    mail to: @message.user.email, subject: "#{CONFIG[:name]} Your #{request.breed.titleize} is over"
  end
  
end
