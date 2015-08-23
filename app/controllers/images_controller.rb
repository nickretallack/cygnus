class ImagesController < ApplicationController
  def show
    @image ||= Upload.find(params[:id]) || Upload.new

    expires_in CONFIG[:image_shelf_life], public: true

    type = params[:type].to_sym

    case type
    when :thumb, :bordered
      file = @image.file.thumb.url
      suffix = "_thumb"
    when :full
      file = @image.file.url
      suffix = ""
    else
      file = File.join(CONFIG[:image_path], CONFIG[type])
    end

    if @image.enabled?
      if stale? etag: @image, last_modified: @image.updated_at
        if not @image.explicit? or current_user.view_adult?
          send_file file || File.join(CONFIG[:image_path], CONFIG["image_not_found#{suffix}".to_sym]), disposition: :inline
        else
          send_file File.join(CONFIG[:image_path], CONFIG["image_adult#{suffix}".to_sym]), disposition: :inline
        end
      end
    else
      send_file File.join(CONFIG[:image_path], CONFIG["image_disabled#{suffix}".to_sym]), disposition: :inline
    end
  end
end