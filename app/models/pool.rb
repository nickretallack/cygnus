class Pool < ActiveRecord::Base
	belongs_to :user
  has_many :submissions
end
