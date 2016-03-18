class OrdersController < ApplicationController

  before_filter only: [:accept, :reject] do
    @order = Order.find(params[Order.slug])
    unless @order
      params[:danger] = "order does not exist"
      back
    end
  end

  def before_save
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
    @order.name = params[:order][:name] if params[:order][:name]
    @order.email = params[:order][:email] if params[:order][:email]
  end

  def after_save
    @form.user.update_attribute(:attachments, @form.user.attachments << "order-#{@order.id}")
    current_user.update_attribute(:attachments, current_user.attachments << "placed_order-#{@order.id}") unless anon?
  end

  def accept
    @order.accepted = true
    @order.decided = true
    @order.save
  end

  def reject
    @order.decided = true
    @order.save
  end

end