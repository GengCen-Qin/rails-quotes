class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  rescue_from ActionController::RoutingError, with: :handle_routing_error

  def handle_routing_error
    redirect_to quotes_path, notice: "未找到指定路由."
  end

  private

  def current_company
    @current_company ||= current_user.company if user_signed_in?
  end

  helper_method :current_company
end
