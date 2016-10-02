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

  def show #these are hard locks, if we put the checks outside the imaging unit, then they are visible with direct links, which is bad!
    if params[Image.slug]
      type = params[:type].to_sym 
      type = nil if type == :full
      type = :thumb if type == :bordered
      if !@image.enabled?
        file = File.join(CONFIG[:image_path], CONFIG[:"image_disabled#{type ? "_#{type}" : ""}"])
      elsif @image.explicit? && params[:adult].blank?
        file = File.join(CONFIG[:image_path], CONFIG[:"image_adult#{type ? "_#{type}" : ""}"])
      else
        file = @image.file.url
        if type
          file = @image.file.versions[type].url if @image.file.versions[type].url
        end
      end
    else
      file = File.join(CONFIG[:image_path], CONFIG[params[:type].to_sym])
    end
    send_file file || File.join(CONFIG[:image_path], CONFIG[:"image_not_found#{type ? "_#{type}" : ""}"]), disposition: :inline, filename: @image.original_filename if stale? etag: @image, last_modified: @image.updated_at
  end

  def download
    send_file @image.file.url || not_found, disposition: :attachment, filename: @image.original_filename if stale? etag: @image, last_modified: @image.updated_at
  end
end