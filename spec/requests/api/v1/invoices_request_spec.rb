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

describe 'find endpoints'do
  before :each do
    merchant = create(:merchant)
    customer = create(:customer)
    create(:invoice, status: "Pending", merchant: merchant, customer: customer)
    @invoice = create(:invoice, status: "Shipped", merchant: merchant, customer: customer)
  end

  it "returns a single invoice based on an id" do
    get "/api/v1/invoices/find?id=#{@invoice.id}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint['status']).to eq(@invoice.status)
  end

  it "returns a single invoice based on a status" do
    get "/api/v1/invoices/find?status=#{@invoice.status}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint['status']).to eq(@invoice.status)
  end

  it "returns a single invoice based on a created date" do
    get "/api/v1/invoices/find?created_at=#{@invoice.created_at}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint['status']).to eq(@invoice.status)
  end

  it "returns a single invoice based on updated date" do
    get "/api/v1/invoices/find?updated_at=#{@invoice.updated_at}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint['status']).to eq(@invoice.status)
  end
end

describe 'find_all endpoints' do
  before :each do
    merchant = create(:merchant)
    customer = create(:customer)
    @invoice1 = Invoice.create!(status: "Shipped",
                                merchant: merchant,
                                customer: customer,
                                created_at: "2000-03-27 14:53:59 UTC",
                                updated_at: "2009-03-27 14:53:59 UTC")
    @invoice2 = Invoice.create!(status: "Paid",
                                merchant: merchant,
                                customer: customer,
                                created_at: "2003-03-27 14:53:59 UTC",
                                updated_at: "2005-03-27 14:53:59 UTC")
    @invoice3 = Invoice.create!(status: "Pending",
                                merchant: merchant,
                                customer: customer,
                                created_at: "2004-03-27 14:53:59 UTC",
                                updated_at: "2005-03-27 14:53:59 UTC")
    @invoice4 = Invoice.create!(status: "Paid",
                                merchant: merchant,
                                customer: customer,
                                created_at: "2000-03-27 14:53:59 UTC",
                                updated_at: "2032-03-27 14:53:59 UTC")
  end

  it "returns a collection of invoices based on an id" do
    get "/api/v1/invoices/find_all?id=#{@invoice1.id}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint.first['status']).to eq(@invoice1.status)
  end

  it "returns a collection of invoices based on a status" do
    get "/api/v1/invoices/find_all?status=#{@invoice1.status}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint.count).to eq(1)
    expect(invoice_endpoint.first['status']).to eq(@invoice1.status)
  end

  it "returns a collection of invoices based on a created date" do
    get "/api/v1/invoices/find_all?created_at=#{@invoice1.created_at}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint.count).to eq(2)
    expect(invoice_endpoint.first['status']).to eq(@invoice1.status)
    expect(invoice_endpoint.last['status']).to eq(@invoice4.status)
  end

  it "returns a collection of invoices based on updated date" do
    get "/api/v1/invoices/find_all?updated_at=#{@invoice2.updated_at}"

    invoice_endpoint = JSON.parse(response.body)

    expect(invoice_endpoint.count).to eq(2)
    expect(invoice_endpoint.first['status']).to eq(@invoice2.status)
    expect(invoice_endpoint.last['status']).to eq(@invoice3.status)
  end
end

describe 'find random' do
  it "returns a random invoice" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice1 = create(:invoice, status: "Pending", merchant: merchant, customer: customer)
    invoice2 = create(:invoice, status: "Shipped", merchant: merchant, customer: customer)

    get "/api/v1/invoices/random"

    invoice_endpoint = JSON.parse(response.body)

    expect(response).to be_success
  end
end
