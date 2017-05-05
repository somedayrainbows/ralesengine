class Api::V1::InvoiceItems::FinderController < ApplicationController

  def show
    render json: InvoiceItem.find_by(param_finder)
  end

  def index
    render json: InvoiceItem.where(param_finder)
  end
end
