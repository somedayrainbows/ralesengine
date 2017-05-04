class ApplicationController < ActionController::API
  def param_finder
    params.permit(:id,
                  :name,
                  :credit_card_number,
                  :result,
                  :created_at,
                  :updated_at)
  end
end
