require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
  end
  test "account_activation" do
    @user = User.new({ name:  "ExampleUser",
                       email: "user@example.com",
                       password: "password",
                       password_confirmation: "password" })
	@user.save  
    mail = UserMailer.account_activation(@user)
    assert_equal "Account activation", mail.subject
    assert_equal [@user.email], mail.to
    assert_match "Hi", mail.body.encoded
  end

  test "password_reset" do
    @user = users(:one)
	@user.create_reset_digest
	
    mail = UserMailer.password_reset(@user)
    assert_equal "Password reset", mail.subject
    assert_equal [@user.email], mail.to
    assert_match "To reset your password click the link below:", mail.body.encoded
  end

end
