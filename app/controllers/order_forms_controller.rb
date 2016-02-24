class OrderFormsController < ApplicationController

  before_filter only: [:index] do
    insist_on :logged_in
  end

  before_filter only: [:create, :edit, :destroy] do
    insist_on :permission, @user
  end

  def after_save
    @user.update_attribute(:attachments, @user.attachments << "order_form-#{@order_form.id}")
  end

  def destroy
    attachments = @user.attachments
    attachments.delete("order_form-#{params[OrderForm.slug]}")
    @user.update_attribute(:attachments, attachments)
    @order_form.destroy
    respond_to do |format|
      format.html {
        flash[:success] = "form destroyed: #{title_for @order_form}"
        back
      }
      format.js
    end
  end

  def update
    params[:order_form][:content] ||= []
    @order_form.update_attribute(:content, params[:order_form][:content].map { |key, value| value }.collect { |value| JSON.parse(value) })
    respond_to do |format|
      format.html { back }
      format.js
    end
  end

  def set_default
    attachments = @user.attachments
    attachments.delete("order_form-#{params[OrderForm.slug]}")
    attachments.unshift("order_form-#{params[OrderForm.slug]}")
    @user.update_attribute(:attachments, attachments)
    respond_to do |format|
      format.html { back }
      format.js
    end
  end
  
end
