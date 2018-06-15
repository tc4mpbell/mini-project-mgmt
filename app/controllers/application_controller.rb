class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def current_organization
    current_user&.organization
  end
  helper_method :current_organization
end
