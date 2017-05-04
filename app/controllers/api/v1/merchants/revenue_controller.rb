class Api::V1::Merchants::RevenueController < ApplicationController

  def show
    render json: Merchant.find(params[:id]), serializer: RevenueSerializer
  end

end
