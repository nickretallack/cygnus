class RequestsController < ApplicationController

  # GET /requests
  # GET /requests.json
  def index
    @title = "Open Requests"
    @requests = Request.all
  end


  # GET /requests/new
  def new
    @title = "New Commission Request"
    @request = Request.new
  end


  def show
    @title = @request.title
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    @request.user = current_user
    
    respond_to do |format|
      if current_user.user? && @request.save
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
end
