class Api::V1::UsersController < ApplicationController
    def show
        user = User.find(user_params[:id])
        render json: UserSerializer.new(user)
    end

    private

    def user_params
        params.permit(:id, :name, :email)
    end
end