class Api::V1::TransactionsController < ApplicationController
  def index
    render json: Transaction.all, except: [:created_at, :updated_at]
  end

  def show
    render json: Transaction.find(params[:id]), except: [:created_at, :updated_at]
  end
end
