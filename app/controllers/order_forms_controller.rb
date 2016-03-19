class OrderFormsController < ApplicationController

  before_filter only: [:index, :show] do
    insist_on :logged_in
  end

  before_filter only: [:create] do
    insist_on :permission, @user
  end

  before_filter only: [:update] do
    unless params[:order_form][:content]
      flash[:danger] = "please add at least one field"
      respond_to do |format|
        format.html { back }
        format.js { back_js }
      end
    end
  end

  def after_save
    @user.update_attribute(:attachments, @user.attachments << "order_form-#{@order_form.id}")
  end

  def before_destroy
    @user.attachments.delete("order_form-#{@order_form.id}")
    @user.save(validate: false)
  end

  def update
    @order_form.title = params[:order_form][:title]
    @order_form.content = params[:order_form][:content]
    @order_form.content = @order_form.content.map { |key, value| value }.collect { |value| JSON.parse(value) }
    respond_to do |format|
      if @order_form.save
        format.html { back }
        format.js
      else
        format.html { back_with_errors }
        format.js { back_with_errors_js }
      end
    end
  end

end
