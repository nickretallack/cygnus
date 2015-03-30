class ImagesController < ApplicationController

  def show
    @image = Upload.find(params[:id])

    expires_in 5.hours, :public => true

    if(!@image.nil? || @image.enabled?)
      if stale?(etag: @image, last_modified: @image.updated_at)
	  if(!@image.explicit? || current_user.view_adult?)
            send_file @image.file_url, :disposition => 'inline'
	  else
	    send_file CONFIG['Image_Adult'], :disposition => 'inline'
	  end

      end
    else
 	  send_file CONFIG['Image_Disabled'], :disposition => 'inline'
    end
  end
  def thumb
    @image = Upload.find(params[:id])

    expires_in 5.hours, :public => true

    if(!@image.nil? || @image.enabled?)
      if stale?(etag: @image, last_modified: @image.updated_at)
	  if(!@image.explicit? || current_user.view_adult?)
	      send_file @image.file.thumb.url, :disposition => 'inline'
	  else
	    send_file CONFIG['Image_Adult_Thumb'], :disposition => 'inline'
	  end
      end
    else
 	  send_file CONFIG['Image_Disabled_Thumb'], :disposition => 'inline'
    end
  end
end
