class Api::V1::Invoices::FinderController < ApplicationController

  def index
    render json: Invoice.where(param_finder)

  end

  def show
    render json: Invoice.find_by(param_finder)
  end

end
