class OrdersController < ApplicationController

  def new
    @order = OrderForm.find(params[OrderForm.slug])
  end

  def create
    @form = OrderForm.find(params[OrderForm.slug])
    @order.content = params[:content].collect{ |key, value| unless value.is_a? Hash; {key => value}; else; {key => value.values.join(", ")}; end; }
    if @order.save
      @form.user.update_attribute(:attachments, @form.user.attachments << "order-#{@order.id}")
      current_user.update_attribute(:attachments, current_user.attachments << "placed_order-#{order.id}") unless anon?
      back
    else
      back
    end
  end

  def show
  end

end