class ImagesController < ApplicationController

  before_filter do
    @image ||= Upload.find(params[:id]) || Upload.new

    expires_in CONFIG[:image_shelf_life], public: true
  end

  def show
    type = params[:type].to_sym

    case type
    when :thumb, :bordered
      file = @image.file.thumb.url
      suffix = "_thumb"
    when :full
      file = @image.file.url
      suffix = ""
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