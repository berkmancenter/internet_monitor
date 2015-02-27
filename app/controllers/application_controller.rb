class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_groups, :set_default_cache_header
  
  rescue_from ActionController::RoutingError, with: :render_not_found

  def load_groups
    access = Category.find_by_slug 'access'
    @groups = DatumSource.where( { category_id: access.id } ).map { |ds| ds.group }.uniq
  end

  def not_found
    raise ActionController::RoutingError.new( 'Not Found' )
  end

  protected

  def set_default_cache_header
    expires_in 1.day, public: true if self.is_a? Refinery::Blog::PostsController
  end

  def render_not_found
    render json: '{ "status": "error", "message": "Not Found" }', status: 404
  end
end
