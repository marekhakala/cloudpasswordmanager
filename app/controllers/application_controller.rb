class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_authentication

  protected
    def configure_authentication
      if self.is_a? StaticPagesController and params[:action] != 'home'
        authenticate_user!
      elsif not self.is_a? StaticPagesController
        authenticate_user!
        configure_devise_permitted_parameters
      end
    end

    def configure_devise_permitted_parameters
      registration_params = [:fullname, :email, :address, :password, :password_confirmation]

      if params[:controller] == 'devise/registrations' and params[:action] == 'create'
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(registration_params) }
      end
    end
end
