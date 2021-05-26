class Api::V1::UsersController < ApplicationController
    before_action :authorize_request, except: :create
    # before_action :find_user, except: :create
    before_action :confirm_password, only: :create

    def show
        render json: UserSerializer.new(@current_user)
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render json: UserSerializer.new(@user)
        else
            render json: {status: "error", messages: @user.errors.full_messages}, status: 400
        end
    end

    def update
        begin
            @current_user.update!(user_params)
        rescue ActiveRecord::RecordInvalid => e
            render json: {error: e.message}, status: :not_acceptable
        else
            render json: UserSerializer.new(@current_user)
        end
    end

    def destroy
        if @current_user.id == params[:id].to_i
            @current_user.destroy!
            render json: { message: 'User successfully deleted'}, status: :accepted
        else
            render json: { error: 'Authorization Conflict, Token and Request ID does not match'}
        end
    end

    private

    def confirm_password
        if user_params[:password] != user_params[:password_confirmation]
            render json: { errors: "Passwords Don't Match"}, status: :conflict
        end
    end

    # def find_user
    #     @user = User.find_by_id!(user_params[:id])
    #     rescue ActiveRecord::RecordNotFound
    #         render json: { errors: 'User not found'}, status: :not_found
    # end

    def user_params
        params.permit(:id, :name, :email, :password, :password_confirmation)
    end
end