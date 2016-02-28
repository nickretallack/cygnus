class OrdersController < ApplicationController

  def place_order
    @no_menu = true
    @form = OrderForm.find(params[OrderForm.slug])
  end

  def create

    if params[:session].select{ |key, value| value == ""}.empty?
      deactivate_session unless anon?
      if cell(:user).(:log_in).to_bool
        back and return
      else
        back and return
      end
    elsif params[:user].select{ |key, value| value == ""}.empty?
      
    end

    raise "break"
  end

end