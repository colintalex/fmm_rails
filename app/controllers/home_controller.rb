class HomeController < ApplicationController
  def index
    render json: 'Hello senor'
  end
end
