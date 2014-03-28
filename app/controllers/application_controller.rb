class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_groups

  def load_groups
    @groups = Group.all
  end
end
