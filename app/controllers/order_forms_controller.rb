class OrderFormsController < ApplicationController
  before_action :set_order_form, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy] 
  before_action :correct_user_or_admin,   only: [:edit, :update, :destroy]
  # GET /order_forms
  # GET /order_forms.json
  def index
    @order_forms = OrderForm.where(:user => current_user).all
  end

  # GET /order_forms/1
  # GET /order_forms/1.json
  def show
  end

  # GET /order_forms/new
  def new
    @order_form = OrderForm.new
  end

  # GET /order_forms/1/edit
  #We don't want users to edit order forms.
  def edit
	
	raise ActionController::RoutingError.new('Not Found')
	
  end

  # POST /order_forms
  # POST /order_forms.json
  def create
    @order_form = OrderForm.new(order_form_params)
	@order_form.user_id = current_user.id
	if(!params[:order_form][:file].nil?)
		params[:order_form][:file].each do |index, file|
			if @order_form.content[index.to_i]["type"] == "image"
				@order_form.content[index.to_i]["contents"] = Upload.render(params[:order_form][:file][index])
			end
		end
	end
    respond_to do |format|
      if @order_form.save
        format.html { redirect_to @order_form, notice: 'Order form was successfully created.' }
        format.json { render :show, status: :created, location: @order_form }
      else
        format.html { render :new }
        format.json { render json: @order_form.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /order_forms/1
  # DELETE /order_forms/1.json
  def destroy
    @order_form.destroy
    respond_to do |format|
      format.html { redirect_to order_forms_url, notice: 'Order form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_form
      @order_form = OrderForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_form_params
      params.require(:order_form).permit(:content, :file)
    end
	def correct_user_or_admin
		unless current_user_or_admin?(@order_form.user)
		  flash[:danger] = "Access Denied"
		  redirect_to(root_url)
		end
	end
end
