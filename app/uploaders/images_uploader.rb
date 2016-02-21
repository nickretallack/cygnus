# encoding: utf-8

class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  before :cache, :save_original_filename

  def save_original_filename(file)
    model.original_filename ||= "#{file.original_filename}"
  end

  storage :file

  def store_dir
    File.join(CONFIG[:upload_path], "#{model.id}")
  end
  
  def md5
    chunk = model.send(mounted_as)
    @md5 ||= Digest::MD5.hexdigest(chunk.read.to_s)
  end

  def filename
    @name ||= "#{md5}#{File.extname(super)}" if super
  end
  
  version :thumb do
    process :resized => [150, 150]
  end

  def resized(width, height)
    manipulate! do |img|
      img.coalesce
      img.resize "#{width}x#{height}^"
      img = yield(img) if block_given?
      img
    end
  end

   def extension_white_list
     %w(jpg jpeg gif png svg)
   end

end
