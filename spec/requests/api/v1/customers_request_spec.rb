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

  it "returns a customers favorite merchant based on successful transactions" do
    customer = create(:customer)
    merchant1 = create(:merchant, name: 'Billy Bobs Bacon')
    merchant2 = create(:merchant, name: 'Sallys Seashells')
    merchant3 = create(:merchant, name: 'Andys Anchors')
    invoice1 = create(:invoice, merchant: merchant1, customer: customer)
    invoice2 = create(:invoice, merchant: merchant2, customer: customer)
    invoice3 = create(:invoice, merchant: merchant3, customer: customer)
    invoice4 = create(:invoice, merchant: merchant3, customer: customer)
    invoice5 = create(:invoice, merchant: merchant2, customer: customer)
    item1 = create(:item, merchant: merchant1)
    InvoiceItem.create(invoice: invoice1, item: item1, quantity: 10)
    InvoiceItem.create(invoice: invoice2, item: item1, quantity: 30)
    InvoiceItem.create(invoice: invoice3, item: item1, quantity: 40)
    InvoiceItem.create(invoice: invoice4, item: item1, quantity: 20)
    InvoiceItem.create(invoice: invoice5, item: item1, quantity: 20)
    create(:transaction, invoice: invoice1, result: 'success')
    create(:transaction, invoice: invoice2, result: 'success')
    create(:transaction, invoice: invoice3, result: 'success')
    create(:transaction, invoice: invoice4, result: 'success')
    create(:transaction, invoice: invoice5, result: 'failed')
    id = customer.id

    get "/api/v1/customers/#{id}/favorite_merchant"

    endpoint_merchant = JSON.parse(response.body)

    expect(endpoint_merchant["name"]).to eq(merchant3.name)
  end
end

describe 'find endpoints'do
  before :each do
    @customer1 = create(:customer)
    @customer2 = create(:customer)
  end

  it "returns a single customer based on an id" do
    get "/api/v1/customers/find?id=#{@customer1.id}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint['first_name']).to eq(@customer1.first_name)
  end

  it "returns a single customer based on a first_name" do
    get "/api/v1/customers/find?first_name=#{@customer1.first_name}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint['first_name']).to eq(@customer1.first_name)
  end

  it "returns a single customer based on a created date" do
    get "/api/v1/customers/find?created_at=#{@customer1.created_at}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint['first_name']).to eq(@customer1.first_name)
  end

  it "returns a single customer based on updated date" do
    get "/api/v1/customers/find?updated_at=#{@customer1.updated_at}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint['first_name']).to eq(@customer1.first_name)
  end
end

describe 'find_all endpoints' do
  before :each do
    @customer1 = create(:customer)
    @customer2 = create(:customer)
  end

  it "returns a collection of customers based on an id" do
    get "/api/v1/customers/find_all?id=#{@customer1.id}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint.first['first_name']).to eq(@customer1.first_name)
  end

  it "returns a collection of customers based on a first_name" do
    get "/api/v1/customers/find_all?first_name=#{@customer1.first_name}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint.count).to eq(1)
    expect(customer_endpoint.first['first_name']).to eq(@customer1.first_name)
  end

  it "returns a collection of customers based on a created date" do
    get "/api/v1/customers/find_all?created_at=#{@customer1.created_at}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint.count).to eq(1)
    expect(customer_endpoint.first['first_name']).to eq(@customer1.first_name)
  end

  it "returns a collection of customers based on updated date" do
    get "/api/v1/customers/find_all?updated_at=#{@customer1.updated_at}"

    customer_endpoint = JSON.parse(response.body)

    expect(customer_endpoint.count).to eq(1)
    expect(customer_endpoint.first['first_name']).to eq(@customer1.first_name)
  end
end

describe 'find random' do
  it "returns a random customer" do
    customer = create(:customer)

    get "/api/v1/customers/random"

    customer_endpoint = JSON.parse(response.body)

    expect(response).to be_success
  end
end
