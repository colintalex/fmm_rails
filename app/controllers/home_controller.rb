class HomeController < ApplicationController
  def index
    render json: 'Hello'
  end
end
