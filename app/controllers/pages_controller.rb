class PagesController < ApplicationController
  def static
    @title = params[:page_name].titleize
    render params[:page_name] rescue raise ActionController::RoutingError.new('Not Found')
  end
end