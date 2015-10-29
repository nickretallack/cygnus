class Attachment < ActiveRecord::Base

  validates :kind, inclusion: { in: :kinds }

  def kinds
    ["image"]
  end

end
