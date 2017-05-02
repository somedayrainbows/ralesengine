class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all, except: [:created_at, :updated_at]
  end

  def show
    render json: Merchant.find(params[:id]), except: [:created_at, :updated_at]
  end
end
