class ApplicationMailer < ActionMailer::Base

  default from: "noreply@#{CONFIG[:host]}"
  layout "mailer"

end
