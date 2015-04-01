class ApplicationMailer < ActionMailer::Base
  default from: "noreply@"+CONFIG["Host"]
  layout 'mailer'
end
