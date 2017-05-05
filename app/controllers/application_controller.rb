class ApplicationController < ActionController::API
  def param_finder
    if params.has_key?(:unit_price)
      {unit_price: (params[:unit_price].to_f*100).round}
    else
      params.permit(:id,
                    :name,
                    :first_name,
                    :last_name,
                    :description,
                    :unit_price,
                    :quantity,
                    :item_id,
                    :customer_id,
                    :invoice_id,
                    :merchant_id,
                    :credit_card_number,
                    :result,
                    :status,
                    :created_at,
                    :updated_at)
    end
  end
end
