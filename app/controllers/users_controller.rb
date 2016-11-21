class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:add_to_basket, :remove_from_basket]

    before_action :authorize, only: [:edit, :update, :destroy, :add_to_basket]
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
            flash[:success] = I18n.t(:user_update_succeed)
            redirect_to edit_user_path
        else
            render :edit
        end
    end

    def destroy
        if @user.admin
            if User.admins.length <= 1
                flash[:error] = I18n.t(:user_need_at_least_one_admin)
                redirect_to root_path
                return
            end
        end

        @user.destroy
        flash[:notice] = I18n.t(:user_destroy_succeed)
        redirect_to root_path
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
