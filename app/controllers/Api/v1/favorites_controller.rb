class Api::V1::FavoritesController < ApplicationController
    before_action :authorize_request
    
    def create
        if @current_user&.favorites.create!(fav_params)
            render json: UserSerializer.new(@current_user)
        end
    end

    def destroy
        fav = @current_user.favorites.find_by_id!(fav_params[:id])
        if fav&.destroy
            @current_user.save
            render json: UserSerializer.new(@current_user)
        end
    end

    private

    def fav_params
        params.permit(:id, :name, :fmid, :address, :dates, :times)
    end
end