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

  it "returns a collection of transactions associated with an invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice1 = create(:invoice, merchant: merchant, customer: customer)
    invoice2 = create(:invoice, merchant: merchant, customer: customer)
    transactions1 = create_list(:transaction, 3, invoice: invoice1)
    transactions2 = create_list(:transaction, 3, invoice: invoice2)
    id1 = invoice1.id

    get "/api/v1/invoices/#{id1}/transactions"

    transactions = JSON.parse(response.body)

    expect(response).to be_success
    expect(transactions.count).to eq(transactions1.count)
    expect(transactions.first["credit_card_number"]).to eq(transactions1.first.credit_card_number)
  end

  it "returns a collection of invoice items associated with an invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    invoice1 = create(:invoice, merchant: merchant, customer: customer)
    invoice2 = create(:invoice, merchant: merchant, customer: customer)
    invoice_items1 = create_list(:invoice_item, 3, invoice: invoice1, item: item, quantity: 1)
    invoice_items2 = create_list(:invoice_item, 3, invoice: invoice2, item: item, quantity: 2)
    id1 = invoice1.id

    get "/api/v1/invoices/#{id1}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_items.count).to eq(invoice_items1.count)
    expect(invoice_items.first["id"]).to eq(invoice_items1.first.id)
  end

  it "returns a collection of items associated with an invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice1 = create(:invoice, merchant: merchant, customer: customer)
    invoice2 = create(:invoice, merchant: merchant, customer: customer)
    items1 = create_list(:item, 3, merchant: merchant, invoices: [invoice1])
    items2 = create_list(:item, 3, merchant: merchant, invoices: [invoice2])
    id1 = invoice1.id

    get "/api/v1/invoices/#{id1}/items"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(items1.count)
    expect(items.first["name"]).to eq(items1.first.name)
  end

  it "returns the customer associated with an invoice" do
    customer1 = create(:customer)
    customer2 = create(:customer)
    merchant = create(:merchant)
    invoice1 = create(:invoice, merchant: merchant, customer: customer1)
    invoice2 = create(:invoice, merchant: merchant, customer: customer2)

    id1 = invoice1.id

    get "/api/v1/invoices/#{id1}/customer"

    customer = JSON.parse(response.body)

    expect(response).to be_success
    expect(customer["first_name"]).to eq(customer1.first_name)
    expect(customer["last_name"]).to eq(customer1.last_name)
  end

  it "returns the merchant associated with an invoice" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    customer = create(:customer)
    invoice1 = create(:invoice, customer: customer, merchant: merchant1)
    invoice2 = create(:invoice, customer: customer, merchant: merchant2)

    id1 = invoice1.id

    get "/api/v1/invoices/#{id1}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant["name"]).to eq(merchant1.name)
  end
end
