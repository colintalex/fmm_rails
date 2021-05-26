class Api::V1::UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: %i[create index]
    def show
        render json: UserSerializer.new(@user)
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render json: UserSerializer.new(@user)
        else
            render json: {status: "error", messages: @user.errors.full_messages}, status: 400
        end
    end

    private

    def find_user
        @user = User.find_by_id!(user_params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'User not found'}, status: :not_found
    end

    def user_params
        params.permit(:id, :name, :email, :password)
    end
end