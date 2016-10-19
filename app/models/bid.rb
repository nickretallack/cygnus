class Bid < ActiveRecord::Base
  belongs_to :slot
  belongs_to :user
end
