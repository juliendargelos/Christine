class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_user_for_login

    private
        def authorize
            redirect_to create_session_path unless current_user
        end

        def set_user_for_login
            unless current_user
                @user = User.new
            end
        end

        def unauthorize
            redirect_to root_path if current_user
        end

        def current_user
            @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end
        helper_method :current_user
end
