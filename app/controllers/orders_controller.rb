class OrdersController < ApplicationController

  def new
    @order = OrderForm.find(params[OrderForm.slug])
  end

  def show
  end

  def create
    @form = OrderForm.find(params[OrderForm.slug])
    @order.content = params[:content].map{ |key, content|
      name = /\d+-(.+)/.match(key)[1]
      if content["answer"] == nil
        { name => { content["question"] => "" } }
      elsif content["answer"].is_a? Hash
        if content["answer"].values.first.is_a? String
          { name => { content["question"] => content["answer"].values } }
        else
          { name => { content["question"] => content["answer"].map{ |index, image|
            "image-#{Image.render(image["image"], image["explicit"])}"
          } } }
        end
      else
        { name => { content["question"] => content["answer"] } }
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