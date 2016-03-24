class SetAdmins < ActiveRecord::Migration
  def up
    User.find("Aurali").update_attribute(:level, "admin")
    User.find("TwilightStormshi").update_attribute(:level, "admin")
  end
end
