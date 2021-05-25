class Api::V1::UsersController < ApplicationController
    def show
        user = User.find_by_id(user_params[:id])
        if user.present?
            render json: UserSerializer.new(user)
        else
            render json: {status: "error", messages: ["Invalid User ID"]}, status: 400
        end
    end

    def create
        user = User.new(user_params)
        if user.save
            render json: UserSerializer.new(user)
        else
            render json: {status: "error", messages: user.errors.full_messages}, status: 400
        end
    end

    private

    def user_params
        params.permit(:id, :name, :email)
    end
end