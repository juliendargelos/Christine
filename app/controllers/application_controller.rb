class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_user_for_login

    private
        def authorize
            unless current_user
                respond_to do |format|
                    format.html { redirect_to create_session_path }
                    format.json { render json: { status: false, message: I18n.t(:you_must_be_logged_in) } }
                end
                false
            else
                true
            end
        end

        def authorize_admin
            if authorize
                unless current_user.admin
                    respond_to do |format|
                        format.html { redirect_to root_path }
                        format.json { render json: { status: false, message: I18n.t(:access_denied) } }
                    end
                    false
                else
                    true
                end
            end
        end

        def set_user_for_login
            unless current_user
                @user = User.new
            end
        end

        def unauthorize
            if current_user
                respond_to do |format|
                    format.html { redirect_to root_path }
                    format.json { render json: { status: false } }
                end
            end
        end

        def current_user
            @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end
        helper_method :current_user

        def current_user_is_admin
            if current_user
                return current_user.admin
            else
                false
            end
        end
        helper_method :current_user_is_admin
end
