class SessionsController < ApplicationController
	before_action :authorize, only: :destroy
	before_action :unauthorize, only: [:new, :create]

	def new
		@user = User.new
	end

	def create
		if session_params[:email] == '' || session_params[:password] == ''
			flash[:error] = I18n.t(:please_fill_email_and_password)
			redirect_to create_session_path
		else
			@user = User.find_by_email(session_params[:email])
			if @user && @user.authenticate(session_params[:password])
				session[:user_id] = @user.id
				flash[:success] = I18n.t(:welcome, firstname: @user.firstname)
				redirect_to root_path
			else
				flash[:error] = I18n.t(:login_failed)
				redirect_to create_session_path
			end
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = I18n.t(:logout_succeed)
		redirect_to create_session_path
	end

	private
		def session_params
			params.require(:user).permit(:email, :password)
		end
end
