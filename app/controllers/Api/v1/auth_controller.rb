class Api::V1::AuthController < ApplicationController
    before_action :authorize_request, except: :login

    def login
        user = User.find_by_email(params[:email])
        if user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            time = Time.now + 2.hours.to_i
            render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), user: user.id}
        else
            render json: {errors: 'Unauthorized'}, status: :unauthorized
        end
    end
end