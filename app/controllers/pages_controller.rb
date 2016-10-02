class PagesController < ApplicationController
  def static
    render params[:page_name] rescue raise ActionController::RoutingError.new('Not Found')
  end
end