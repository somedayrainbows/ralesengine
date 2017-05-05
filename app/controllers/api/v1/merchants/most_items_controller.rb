class Api::V1::Merchants::MostItemsController < ApplicationController

  def index
    render json: Merchant.most_items(params[:quantity]), each_serializer: MostItemsSerializer
  end

end
