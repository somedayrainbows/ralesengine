class Api::V1::Customers::FinderController < ApplicationController

  def index
    render json: Customer.where(param_finder)

  end

  def show
    render json: Customer.find_by(param_finder)
  end

end
