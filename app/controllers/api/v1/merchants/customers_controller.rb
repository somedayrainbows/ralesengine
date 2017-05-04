class Api::V1::Merchants::CustomersController < ApplicationController

  def index
    render json: Merchant.find(params[:id]), serializer: CustomersPendingInvoicesSerializer
  end
end
