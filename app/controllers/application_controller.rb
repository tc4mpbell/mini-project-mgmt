class ApplicationController < ActionController::Base
  def current_organization
    current_user.organization
  end
  helper_method :current_organization
end
