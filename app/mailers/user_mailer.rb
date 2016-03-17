class UserMailer < ApplicationMailer

  def activation(user)
    @user = user
    attachments.inline["logo.png"] = File.read(File.join(CONFIG[:image_path], CONFIG[:logo_email]))
    mail to: @user.email, subject: "#{CONFIG[:name]} account activation"
  end

  def reset(user)
    @user = user
    attachments.inline["logo.png"] = File.read(File.join(CONFIG[:image_path], CONFIG[:logo_email]))
    mail to: @user.email, subject: "#{CONFIG[:name]} password reset"
  end
end
