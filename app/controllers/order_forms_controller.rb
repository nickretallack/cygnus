class OrderFormsController < ApplicationController
  before_filter -> { insist_on :logged_in }, only: [:new, :create]
  before_filter -> { insist_on :permission, @order_form.user }, only: [:edit, :update, :destroy]
  
  def index
  	@user = User.find(params[User.slug])
    @order_forms = @user.order_forms
  end

  def show
    @user = User.find(params[User.slug])
  end

  def new
  	@user = User.find(params[User.slug])
    @order_form = OrderForm.new
  end

  def edit
    not_found
  end

  def create
	@new_order_form.user_id = current_user.id
  raise "break"
	if(!params[:order_form][:file].nil?)
		params[:order_form][:file].each do |index, file|
			if @new_order_form.content[index.to_i]["type"] == "image"
				@new_order_form.content[index.to_i]["contents"] = Upload.render(params[:order_form][:file][index])
			end
		end
	end
    respond_to do |format|
      if @new_order_form.save
        format.html { redirect_to order_form_path(current_user, @new_order_form), notice: 'Order form was successfully created.' }
        format.json { render :show, status: :created, location: order_form_path(current_user, order_form) }
      else
		@order_form = @new_order_form
        format.html { render :new }
        format.json { render json: @order_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order_form.destroy
    respond_to do |format|
      format.html { redirect_to order_forms_url, notice: 'Order form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def order_form_params_permitted
    [:content, :file]
  end
end
