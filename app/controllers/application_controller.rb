class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_groups

  def load_groups
    access = Category.find_by_slug 'access'
    @groups = DatumSource.where( { category_id: access.id } ).map { |ds| ds.group }.uniq
    
  end
end
