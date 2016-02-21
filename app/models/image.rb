class Image < ActiveRecord::Base
  mount_uploader :file, ImagesUploader
  validates :md5, presence: true

  def self.render(upload_data, explicit = false)
    @this = Upload.new(file: upload_data)
    @that = Upload.find_by(md5: @this.file.md5)
    unless @that
      @this.md5 = @this.file.md5
      @this.explicit = explicit
      (not upload_data.blank? and @this.save)? @this.id : nil
    else
      @this.destroy
      @that.id
    end
  end

end
