class OrdersController < ApplicationController

  before_filter only: [:new] do
    @order = OrderForm.find(params[OrderForm.slug])
    unless @order and @order.user
      flash[:danger] = "order form has been deleted. Please contact the artist for an updated link"
      shunt_to_root
    end
  end

  before_filter only: [:new] do
    if @order.content.empty?
      flash[:danger] = "order form is blank. Please contact the artist for an updated link"
      shunt_to_root
    end
  end

  before_filter only: [:new] do
    if current_user? @order.user
      flash[:danger] = "can't order from yourself"
      shunt_to_root
    end
  end

  before_filter only: [:new] do
    unless can_order? @order.user
      flash[:danger] = "#{@order.user.name} is not accepting commissions at this time"
      shunt_to_root
    end
  end

  before_filter only: [:create] do
    @form = OrderForm.find(params[OrderForm.slug])
  end

  before_filter only: [:accept] do
    unless @user.card.cards.first
      card = Card.new(title: "To Do")
      card.save(validate: false)
      top_card = @user.card
      top_card.attachments << "card-#{card.id}"
      top_card.save(validate: false)
    end
  end
  
  def create
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
    if anon?
      @order.name = params[:order][:name].blank?? AnonymousUser.new.name : params[:order][:name] rescue AnonymousUser.new.name
      @order.email = params[:order][:email].blank?? AnonymousUser.new.email : params[:order][:email] rescue AnonymousUser.new.email
    end
    if @order.save
      unless anon?
        user = current_user
        user.attachments << "placed_order-#{@order.id}"
        user.save(validate: false)
      end
      user = @form.user
      user.attachments << "order-#{@order.id}"
      user.save(validate: false)
      Message.order(current_user, @order)
      flash[:success] = "order placed with #{@form.user.name}"
      respond_to do |format|
        format.html { redirect_to :root }
        format.js { root_js }
      end
    else
      danger_routes
    end
  end

  def index
    paginate @user.placed_orders.reverse
  end

  def accept
    @order.accepted = true
    @order.decided = true
    @order.save(validate: false)
    user = current_user
    user.attachments.delete("order-#{@order.id}")
    user.save(validate: false)
    @list = @user.card.cards.first
    @card = Card.new(title: "Order from #{@order.patron_name}")
    @card.attachments << "order-#{@order.id}"
    @card.save(validate: false)
    @list.attachments << "card-#{@card.id}"
    @list.save(validate: false)
    Message.accept_order(current_user, @order)
    success_routes("order accepted")
  end

  def reject
    @order.decided = true
    @order.save(validate: false)
    user = current_user
    user.attachments.delete("order-#{@order.id}")
    user.save(validate: false)
    Message.reject_order(current_user, @order)
    success_routes("order rejected")
  end

end