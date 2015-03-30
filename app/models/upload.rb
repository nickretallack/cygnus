class Upload < ActiveRecord::Base
  mount_uploader :file, ImagesUploader	

  def self.render(upload_data)
	
	@this = Upload.new(file: upload_data)
	if !upload_data.blank? && @this.save
	  @this.id
	else
	  nil
	end
  end
  def self.render_multiple(upload_data)
    
  end
end
