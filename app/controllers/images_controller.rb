class ImagesController < ApplicationController

  def show
    logo = params[:type] == "logo"
    thumb = params[:type] == "thumb"
    suffix = (thumb)? "_thumb" : ""

    begin
      @image = Upload.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @image = Upload.new
    end

    expires_in CONFIG[:image_shelf_life], public: true

    #raise "break"

    if @image.enabled?
      if stale? etag: @image, last_modified: @image.updated_at
    	  if not @image.explicit? or current_user.view_adult?
          send_file ((thumb)? @image.file.thumb.url : @image.file_url) || (logo)? CONFIG[:logo] : CONFIG["image_disabled#{suffix}".to_sym], :disposition => "inline"
    	  else
    	    send_file CONFIG["image_adult#{suffix}".to_sym], :disposition => "inline"
    	  end
      end
    else
 	    send_file CONFIG["image_disabled#{suffix}".to_sym], :disposition => "inline"
    end
  end
end