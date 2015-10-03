class OrderFormsController < ApplicationController
  before_filter -> { insist_on :logged_in }, only: [:show]
  before_filter -> { insist_on :permission, @order_form.nil?? User.find(params[User.slug]) : @order_form.user }, except: [:show]
  
  def index
  	@user = User.find(params[User.slug])
    @order_forms = @user.order_forms
  end

  def show
    @user = User.find(params[User.slug])
  end

  def create
  	@new_order_form.user_id = current_user.id
    @new_order_form.content = JSON.parse(params[:order_form][:content])
  	# if(!params[:order_form][:files].nil?)
  	# 	params[:order_form][:files].each do |index, file|
  	# 		if @new_order_form.content[index.to_i]["type"] == "image"
  	# 			@new_order_form.content[index.to_i]["contents"] = Upload.render(params[:order_form][:file][index])
  	# 		end
  	# 	end
  	# end
    if @new_order_form.save
      back
    else
      back_with_errors
    end
  end

  def destroy
    current_user.update_attribute(:default_order_form, nil) if current_user.default_order_form == @order_form.id
    @order_form.destroy
    flash[:success] = "form destroyed"
    back
  end

  def set_default
    current_user.update_attribute(:default_order_form, @order_form.id)
    back
  end

  def order
    
  end

  private

  def order_form_params_permitted
    [:title, :content, :files]
  end
end
