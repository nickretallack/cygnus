class OrdersController < ApplicationController

  def new
    @order = OrderForm.find(params[OrderForm.slug])
  end

  def show
  end

  def create
    @form = OrderForm.find(params[OrderForm.slug])
    @order.content = params[:content].collect{ |key, value|
      unless value.is_a? Hash
        {key => value}
      else
        unless value.values.first.is_a? Hash and value.values.first.key? "image"
          {key => value.values.join(", ")}
        else
          {key => value.values.map{ |value| "image-#{Image.render(value["image"], value["explicit"])}" }}
        end
      end
    }
    if @order.save
      @form.user.update_attribute(:attachments, @form.user.attachments << "order-#{@order.id}")
      current_user.update_attribute(:attachments, current_user.attachments << "placed_order-#{@order.id}") unless anon?
      back
    else
      back
    end
  end

  def accept
  end

  def reject
  end

end