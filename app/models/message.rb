class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :sender, class_name: "User"
end
