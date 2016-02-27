class OrdersController < ApplicationController

  def place_order
    @form = OrderForm.find(params[OrderForm.slug])
  end

end