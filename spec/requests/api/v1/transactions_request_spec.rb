require 'rails_helper'

describe "Transactions API" do
  it "sends a list of transactions" do

    invoice = Invoice.create(status: 'Paid')
    create_list(:transaction, 3, invoice: invoice)

    get '/api/v1/transactions'

    expect(response).to be_success

    transactions = JSON.parse(response.body)

    expect(transactions.count).to eq(3)
    expect(transactions.first).to have_key("credit_card_number")
    expect(transactions.first).to have_key("result")
  end

  it "can get one transaction by its id" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = Invoice.create!(status: 'Paid', merchant: merchant, customer: customer)
    transaction = create_list(:transaction, 3, invoice: invoice).first
    id = transaction.id

    get "/api/v1/transactions/#{id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_success
    expect(transaction["id"]).to eq(id)
  end
end
