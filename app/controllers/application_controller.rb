class ApplicationController < ActionController::API
  def param_finder
    params.permit(:id,
                  :name,
                  :first_name,
                  :last_name,
                  :credit_card_number,
                  :result,
                  :status,
                  :created_at,
                  :updated_at)
  end
end
