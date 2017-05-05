class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    render json: Merchant.revenue(date_finder), serializer: TotalRevenueSerializer
  end

  def show
    render json: Merchant.find(params[:id]).revenue(date_finder), serializer: RevenueSerializer
  end

  private

  def date_finder
    {created_at: params['date']} if params.key?('date')
  end
end
