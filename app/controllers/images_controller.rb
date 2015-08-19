class ImagesController < ApplicationController
  def show
    begin
      @image = Upload.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @image = Upload.new
    end

    expires_in CONFIG[:image_shelf_life], public: true

    case params[:type]
    when "thumb"
      file = @image.file.thumb.url
      suffix = "_thumb"
    when "logo"
      file = CONFIG[:logo]
    when "banner"
      file = CONFIG[:banner]
    else
      file = @image.file.url
      suffix = ""
    end

    if @image.enabled?
      if stale? etag: @image, last_modified: @image.updated_at
        if not @image.explicit? or current_user.view_adult?
          send_file file || CONFIG["image_disabled#{suffix}".to_sym], :disposition => "inline"
    	  else
    	    send_file CONFIG["image_adult#{suffix}".to_sym], :disposition => "inline"
    	  end
      end
    else
 	    send_file CONFIG["image_disabled#{suffix}".to_sym], :disposition => "inline"
    end
  end
end