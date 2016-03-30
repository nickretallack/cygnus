class ImagesController < ApplicationController

  before_filter do
    @image ||= Image.find(params[Image.slug]) || Image.new

    expires_in CONFIG[:image_shelf_life], public: true
  end

  before_filter only: [:download] do
    if @image == Image.new
      render nothing: true
    end
  end

  def show
    type = params[:type].to_sym

    case type
    when :bordered
      file = @image.file.thumb.url
      suffix = "_thumb"
    when :limited
      file = @image.file.limited.url
      unless File.exist?(file)
        file = @image.file.url
      end
    when :medium
      file = @image.file.medium.url
      unless File.exist?(file)
        file = @image.file.url
      end
    when :full
      file = @image.file.url
    else
      begin
        file = File.join(CONFIG[:image_path], CONFIG[type])
      rescue
        file = nil
      end
    end

    unless file.nil? or File.exist?(file)
      file = nil
    end

    send_file file || File.join(CONFIG[:image_path], CONFIG["image_not_found#{suffix}".to_sym]), disposition: :inline, filename: @image.original_filename if stale? etag: @image, last_modified: @image.updated_at
  end

  def download
    send_file @image.file.url || not_found, disposition: :attachment, filename: @image.original_filename if stale? etag: @image, last_modified: @image.updated_at
  end
end