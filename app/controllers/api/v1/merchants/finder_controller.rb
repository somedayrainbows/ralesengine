class Api::V1::Merchants::FinderController < ApplicationController

  def show
    render json: Merchant.find_by(param_finder)
  end
  
  def index
    render json: Merchant.where(param_finder)
  end
end
