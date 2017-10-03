class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActionController::RoutingError, with: :render_not_found

  def not_found
    raise ActionController::RoutingError.new( 'Not Found' )
  end

  protected

  def render_not_found
    render json: '{ "status": "error", "message": "Not Found" }', status: 404
  end
end
