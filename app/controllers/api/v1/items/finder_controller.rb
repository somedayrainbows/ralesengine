class Api::V1::Items::FinderController < ApplicationController

  def show
    render json: Item.find_by(param_finder)
  end

  def index
    render json: Item.where(param_finder)
  end
end
