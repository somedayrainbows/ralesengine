require 'rails_helper'

describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_success

    customers = JSON.parse(response.body)

    expect(customers.count).to eq(3)
    expect(customers.first).to have_key("first_name")
    expect(customers.first).to have_key("last_name")
  end

  it "can get one customer by its id" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_success
    expect(customer["id"]).to eq(id)
  end

  it "returns a collection of associated invoices" do
    merchant = create(:merchant)
    customer1, customer2 = create_list(:customer, 2)
    invoice1 = create(:invoice, merchant: merchant, customer: customer1)
    invoice2 = create(:invoice, merchant: merchant, customer: customer2)
    id = customer1.id

    get "/api/v1/customers/#{id}/invoices"

    invoices = JSON.parse(response.body)

    expect(response).to be_success
    expect(customer1.invoices.first).to eq(invoice1)
    expect(customer1.invoices.first).to_not eq(invoice2)
  end

  it "returns a collection of associated transactions" do
    merchant = create(:merchant)
    customer1, customer2 = create_list(:customer, 2)
    invoice1 = create(:invoice, merchant: merchant, customer: customer1)
    invoice2 = create(:invoice, merchant: merchant, customer: customer2)
    id = customer1.id
    create_list(:transaction, 3, invoice: invoice1)

    get "/api/v1/customers/#{id}/transactions"

    transactions = JSON.parse(response.body)

    expect(response).to be_success
    expect(transactions.count).to eq(customer1.transactions.count)
    expect(transactions.first["id"]).to eq(customer1.transactions.first.id)
  end
end
