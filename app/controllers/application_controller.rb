class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_groups, :load_map_countries

  def load_groups
    access = Category.find_by_slug 'access'
    @groups = DatumSource.where( { category_id: access.id } ).map { |ds| ds.group }.uniq
  end

  def load_map_countries
    @map_countries = Country.with_enough_data.select( 'id,iso3_code,score' )
  end
end
