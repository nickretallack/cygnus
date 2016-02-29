class OrdersController < ApplicationController

  def place_order
    @order = OrderForm.find(params[OrderForm.slug])
  end

  def create
    raise "break"
  end

end