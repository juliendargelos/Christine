class UsersController < ApplicationController
    before_action :authorize, only: [:edit, :update, :destroy]
    before_action :unauthorize, only: [:new, :create]

    before_action :set_user, only: [:edit, :update, :destroy]
    before_action :set_birthdate_boundaries, only: [:new, :edit, :create, :update]

    def new
        @user = User.new
    end

    def edit
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id
            flash[:success] = I18n.t(:welcome, firstname: @user.firstname)
            redirect_to root_path
        else
            render :new
        end
    end

    def update
        if @user.update(user_params)
            flash[:success] = I18n.t(:user_update_informations_succeed)
            redirect_to edit_user_path
        else
            render :edit
        end
    end

    def destroy
        @user.destroy
        redirect_to root_path, notice: I18n.t(:user_unsubscribing_succeed)
    end

    private
        def set_user
            @user = current_user
        end

        def set_birthdate_boundaries
            @birthdate_boundaries = User.birthdate_boundaries
        end

        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation, :firstname, :lastname, :birthdate)
        end
end
