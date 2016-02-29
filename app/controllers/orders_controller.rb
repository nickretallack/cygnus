class OrdersController < ApplicationController

  def new
    @order = OrderForm.find(params[OrderForm.slug])
  end

  def create
    @form = OrderForm.find(params[OrderForm.slug])
    @order.content = params[:content].map{ |key, value| {key.split("-")[1]=>value} }.collect{ |item| key, value = item.first; unless value.is_a? Hash; item; else; {key=>value.values.join(", ")}; end; }
    @order.save
    back
  end

end