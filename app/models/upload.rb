class Upload < ActiveRecord::Base
  mount_uploader :file, ImagesUploader	
  validates :md5, presence: true
  
  #builds an upload file and pushes certain params to DB for later calling. 
  def self.render(upload_data, explicit = false)
  	@this = Upload.new(file: upload_data)
  	@that = Upload.find_by(md5: @this.file.md5)
  	if @that.nil?
  		@this.md5 = @this.file.md5
  		@this.explicit = explicit
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
