class Api::V1::Transactions::FinderController < ApplicationController

  def show
    render json: Transaction.find_by(param_finder)
  end

  def index
    render json: Transaction.where(param_finder)
  end
end
