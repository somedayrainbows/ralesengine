class ApplicationController < ActionController::API
  def param_finder
    find = params.permit(:id, :name, :created_at, :updated_at)
  end
end
