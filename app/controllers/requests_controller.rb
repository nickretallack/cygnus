class RequestsController < ApplicationController

  # GET /requests
  # GET /requests.json
  def index
    @title = "Open #{params[:breed].titleize}s"
    @requests = Request.all.where(breed: params[:breed]).reject(&:expired?)
  end


  # GET /requests/new
  def new
    @title = "New Commission #{params[:breed].titleize}"
    @request = Request.new(breed: params[:breed])
  end

  before_filter only: [:accept] do
    unless current_user.card.cards.first
      card = Card.new(title: "To Do")
      card.save(validate: false)
      top_card = current_user.card
      top_card.attachments << "card-#{card.id}"
      top_card.save(validate: false)
    end
  end

  def show
    @title = @request.title
  end
  
  def request_bid
    @bid = Bid.find(params[:bid])
    redirect_to request_path @bid.slot.request, anchor: "bid-#{@bid.id}"
  end
  
  def accept
    @bid = Bid.find(params[:bid])
    if  @user == current_user
      @list = @user.card.cards.first
      @card = Card.new(title: "Order From #{@bid.user.name}")
      @card.attachments << "bid-#{@bid.id}"
      @card.save(validate: false)
      @list.attachments << "card-#{@card.id}"
      @list.save(validate: false)
      Message.accept_bid @user, @bid
      flash[:success] = "Bid added to your workboard for final confirmation"
      back
    else
      flash[:errors] = "Access Denied"
      back
    end
  end

  # POST /requests
  # POST /requests.json
  def bid
    @bid = Bid.new(bid_params)
    request = Request.find(params[:id])
    @bid.user = current_user
    
    respond_to do |format|
      if current_user.user? && !request.expired? && @bid.slot.valid_bid?(request, @bid) && @bid.save
        puts @bid.slot.bid_flag

        Message.outbid(@bid) if @bid.slot.bid_flag
        format.html { redirect_to :back,  notice: 'bid added successfully' }
        format.json { render  json: @bid }
      else
        format.html { redirect_to :back, error: "An Error has occurred, try again"}
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create
    @request = Request.new(request_params)
    @request.user = current_user
    @request.image_id = Image.render(params[:image][:image], params[:image][:explicit]) if params[:image][:image]
    
    respond_to do |format|
      if current_user.user? && @request.save
        MessageMailer.time_over(@request).deliver_later(wait: @request.auction_length.days)
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:body, :max_price, :breed, :auction_length, :title,
                                      slots_attributes: [:title, :body, :min_bid, :auto_buy])
    end
    def bid_params
      params.require(:bid).permit(:body, :amount, :slot_id)
    end
end
