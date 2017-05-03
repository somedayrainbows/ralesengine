require 'rails_helper'

describe "Invoices API" do
  # let(:merchant) { FactoryGirl.create :merchant }
  it "sends a list of invoices" do
    merchant = Merchant.create!(name: "Lady Jane")
    customer = Customer.create!(first_name: "Sally", last_name: "O'Malley")
    invoices = create_list(:invoice, 3, merchant: merchant, customer: customer)

    get '/api/v1/invoices'

    expect(response).to be_success

    invoices = JSON.parse(response.body)

    expect(invoices.count).to eq(3)
    expect(invoices.first).to have_key("status")
  end

  it "can get one invoice by its id" do
    merchant = Merchant.create!(name: "Lady Jane")
    customer = Customer.create!(first_name: "Sally", last_name: "O'Malley")
    invoice = create_list(:invoice, 3, merchant: merchant, customer: customer).first
    id = invoice.id

    get "/api/v1/invoices/#{id}"

       invoice = JSON.parse(response.body)

       expect(response).to be_success
       expect(invoice["id"]).to eq(id)
  end
end
