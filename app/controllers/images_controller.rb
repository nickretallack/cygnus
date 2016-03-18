class ImagesController < ApplicationController

  before_filter do
    @image ||= Image.find(params[Image.slug]) || Image.new

    expires_in CONFIG[:image_shelf_life], public: true
  end

  before_filter only: [:download] do
    insist_on :referer
  end

  before_filter only: [:download] do
    if @image == Image.new
      flash[:danger] = "file not found"
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
    when :medium
      file = @image.file.medium.url
    when :full
      file = @image.file.url
    else
      begin
        file = File.join(CONFIG[:image_path], CONFIG[type])
      rescue
        file = nil
      end
    end

    send_file file || File.join(CONFIG[:image_path], CONFIG["image_not_found#{suffix}".to_sym]), disposition: :inline, filename: @image.original_filename if stale? etag: @image, last_modified: @image.updated_at
  end

  def download
    send_file @image.file.url || not_found, disposition: :attachment, filename: @image.original_filename if stale? etag: @image, last_modified: @image.updated_at
  end
end