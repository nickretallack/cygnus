class AttachmentsController < ApplicationController

  def create
    @new_attachment.kind = params[:kind]
    case @new_attachment.kind
    when "image"
      @new_attachment.attachment_id = Upload.render(params[:attachment][:upload][:image], params[:attachment][:upload][:explicit])
      @new_attachment.confirmed = true
      @new_attachment.decided = true
    end
    respond_to do |format|
      if @new_attachment.save
        format.html { back }
        format.js
      else
        format.html { back_with_errors }
        format.js
      end
    end
  end

  private

  def attachment_params_permitted
    [:kind, :upload]
  end
  
end
