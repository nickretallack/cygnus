class Submission < ActiveRecord::Base
 #has_and_belongs_to_many :users
 belongs_to :upload, foreign_key: :file_id
end
