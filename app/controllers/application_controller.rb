class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
end
