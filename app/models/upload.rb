class Upload < ActiveRecord::Base
  mount_uploader :file, ImagesUploader	
  validates :md5, presence: true
  
  def self.render(upload_data)
	
	@this = Upload.new(file: upload_data)
	@this.md5 = @this.file.md5
	@that = Upload.find_by(md5: @this.md5)
	if @that.nil?
		if !upload_data.blank? && @this.save
		  @this.id
		else
		  nil
		end
	else
		@this.destroy
		@that.id
	end
  end
  def self.render_multiple(upload_data)
  end
end
