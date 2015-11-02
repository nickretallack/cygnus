class AttachmentsController < ApplicationController

  def new
    send_data {attachment: cell(:attachment).(:new, parent_model: params[:parent_model], parent_id: params[:parent_id], child_model: params[:type]}.to_json
  end

  def create
    @new_attachment.child_model = @new_attachment.child_model.downcase
    case @new_attachment.child_model
    when "image"
      @new_attachment.child_id = Upload.render(params[:attachment][:upload][:image], params[:attachment][:upload][:explicit])
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

  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { back }
      format.js
    end
  end

  private

  def attachment_params_permitted
    [:parent_model, :parent_id, :child_model]
  end
  
end
