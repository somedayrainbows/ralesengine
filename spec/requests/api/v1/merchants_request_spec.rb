require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_success

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq(3)
    expect(merchants.first).to have_key("name")
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant["id"]).to eq(id)
  end

  it "returns a collection of items associated with that merchant" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    items1 = create_list(:item, 3, merchant: merchant1)
    items2 = create_list(:item, 3, merchant: merchant2)
    id1 = merchant1.id

    get "/api/v1/merchants/#{id1}/items"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(items1.count)
    expect(items.first["name"]).to eq(items1.first.name)
  end

  it "returns a collection of invoices associated with that merchant from their known orders" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    customer = create(:customer)
    invoices1 = create_list(:invoice, 3, merchant: merchant1, customer: customer)
    invoices2 = create_list(:invoice, 3, merchant: merchant2, customer: customer)
    id1 = merchant1.id

    get "/api/v1/merchants/#{id1}/invoices"

    invoices = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoices.count).to eq(invoices1.count)
    expect(invoices.first["status"]).to eq(invoices1.first.status)
  end

  describe 'find endpoints' do
    before :each do
      create(:merchant, name: 'Sallys Seashells')
      @merchant = create(:merchant, name: 'Billy Bob Bacon')
    end

    it "returns a single merchant based on an id" do
      get "/api/v1/merchants/find?id=#{@merchant.id}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint['name']).to eq(@merchant.name)
    end

    it "returns a single merchant based on a name" do
      get "/api/v1/merchants/find?name=#{@merchant.name}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint['name']).to eq(@merchant.name)
    end

    it "returns a single merchant based on a created date" do
      get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint['name']).to eq(@merchant.name)
    end

    it "returns a single merchant based on updated date" do
      get "/api/v1/merchants/find?updated_at=#{@merchant.updated_at}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint['name']).to eq(@merchant.name)
    end
  end

  describe 'find_all endpoints' do
    before :each do
      @merchant1 = Merchant.create!(name: "Jack Black",
                                    created_at: "2000-03-27 14:53:59 UTC",
                                    updated_at: "2009-03-27 14:53:59 UTC")
      @merchant2 = Merchant.create!(name: "Jack Black",
                                    created_at: "2003-03-27 14:53:59 UTC",
                                    updated_at: "2005-03-27 14:53:59 UTC")
      @merchant3 = Merchant.create!(name: "Jack Velendez",
                                    created_at: "2004-03-27 14:53:59 UTC",
                                    updated_at: "2005-03-27 14:53:59 UTC")
      @merchant4 = Merchant.create!(name: "Jane Sauro",
                                    created_at: "2000-03-27 14:53:59 UTC",
                                    updated_at: "2032-03-27 14:53:59 UTC")
    end
    
    it "returns a collection of merchants based on an id" do
      get "/api/v1/merchants/find_all?id=#{@merchant1.id}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint.first['name']).to eq(@merchant1.name)
    end

    it "returns a collection of merchants based on a name" do
      get "/api/v1/merchants/find_all?name=#{@merchant1.name}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint.count).to eq(2)
      expect(merchant_endpoint.first['name']).to eq(@merchant1.name)
    end

    it "returns a collection of merchants based on a created date" do
      get "/api/v1/merchants/find_all?created_at=#{@merchant1.created_at}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint.count).to eq(2)
      expect(merchant_endpoint.first['name']).to eq(@merchant1.name)
      expect(merchant_endpoint.last['name']).to eq(@merchant4.name)
    end

    it "returns a collection of merchants based on updated date" do
      get "/api/v1/merchants/find_all?updated_at=#{@merchant2.updated_at}"

      merchant_endpoint = JSON.parse(response.body)

      expect(merchant_endpoint.count).to eq(2)
      expect(merchant_endpoint.first['name']).to eq(@merchant2.name)
      expect(merchant_endpoint.last['name']).to eq(@merchant3.name)
    end
  end

  describe 'find random' do
    it "returns a random merchant" do
      create(:merchant, name: 'Sallys Seashells')
      create(:merchant, name: 'Billy Bob Bacon')

      get "/api/v1/merchants/random"

      JSON.parse(response.body)

      expect(response).to be_success
    end
  end

  describe 'business intelligence' do
    it "returns the total revenue for a merchant" do
      customer = create(:customer)
      merchant = create(:merchant, name: 'Billy Bob Bacon')
      invoice = create(:invoice, merchant: merchant, customer: customer)
      items = create_list(:item, 2, merchant: merchant)
      InvoiceItem.create(invoice: invoice, item: items.first, unit_price: 1000, quantity: 2)
      InvoiceItem.create(invoice: invoice, item: items.second, unit_price: 2500, quantity: 3)
      create(:transaction, invoice: invoice)

      get "/api/v1/merchants/#{merchant.id}/revenue"
      merchant_endpoint = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_endpoint).to eq("revenue" => "95.0")
    end

    it "returns the total revenue for a merchant on a date" do
      customer = create(:customer)
      merchant = create(:merchant, name: 'Billy Bob Bacon')
      invoice1 = create(:invoice, merchant: merchant, customer: customer, created_at: '2012-03-16 11:55:05')
      invoice2 = create(:invoice, merchant: merchant, customer: customer, created_at: '2012-03-15 11:55:05')
      items = create_list(:item, 2, merchant: merchant)
      InvoiceItem.create(invoice: invoice1, item: items.first, unit_price: 1000, quantity: 2)
      InvoiceItem.create(invoice: invoice2, item: items.second, unit_price: 2500, quantity: 3)
      InvoiceItem.create(invoice: invoice2, item: items.second, unit_price: 2500, quantity: 3)
      create(:transaction, invoice: invoice1)
      create(:transaction, invoice: invoice2)

      get "/api/v1/merchants/#{merchant.id}/revenue?date='2012-03-16 11:55:05'"
      merchant_endpoint = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_endpoint).to eq("revenue" => "20.0")
    end

    it "returns the top x merchants ranked by total number of items sold" do
      customer = create(:customer)
      merchant1 = create(:merchant, name: 'Billy Bobs Bacon')
      merchant2 = create(:merchant, name: 'Sallys Seashells')
      merchant3 = create(:merchant, name: 'Andys Anchors')
      merchant4 = create(:merchant, name: 'Dannys Dentures')
      invoice1 = create(:invoice, merchant: merchant1, customer: customer)
      invoice2 = create(:invoice, merchant: merchant2, customer: customer)
      invoice3 = create(:invoice, merchant: merchant3, customer: customer)
      invoice4 = create(:invoice, merchant: merchant4, customer: customer)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant2)
      item3 = create(:item, merchant: merchant3)
      item4 = create(:item, merchant: merchant4)
      InvoiceItem.create(invoice: invoice1, item: item1, quantity: 10)
      InvoiceItem.create(invoice: invoice2, item: item2, quantity: 30)
      InvoiceItem.create(invoice: invoice3, item: item3, quantity: 40)
      InvoiceItem.create(invoice: invoice4, item: item4, quantity: 20)
      create(:transaction, invoice: invoice1)
      create(:transaction, invoice: invoice2)
      create(:transaction, invoice: invoice3)
      create(:transaction, invoice: invoice4)

      get "/api/v1/merchants/most_items?quantity=3"
      merchant_endpoint = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_endpoint.count).to eq(3)
      expect(merchant_endpoint.first['name']).to eq(merchant3.name)
      expect(merchant_endpoint.second['name']).to eq(merchant2.name)
      expect(merchant_endpoint.third['name']).to eq(merchant4.name)
      expect(merchant_endpoint.first['items_sold']).to eq(40)
      expect(merchant_endpoint.second['items_sold']).to eq(30)
      expect(merchant_endpoint.third['items_sold']).to eq(20)
    end

    it "returns a collection of customers that have pending (unpaid) invoices" do
      customers = create_list(:customer, 2)
      merchant = create(:merchant)
      invoice1 = create(:invoice, customer: customers.first, merchant: merchant)
      invoice2 = create(:invoice, customer: customers.last, merchant: merchant)
      create(:transaction, invoice: invoice1, result: "failed")
      create(:transaction, invoice: invoice1, result: "success")
      create(:transaction, invoice: invoice2, result: "failed")
      create(:transaction, invoice: invoice2, result: "failed")
      id = merchant.id

      get "/api/v1/merchants/#{id}/customers_with_pending_invoices"

      merchant_endpoint = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant_endpoint.count).to eq(1)
      expect(merchant_endpoint.first["first_name"]).to eq(customers.last.first_name)
    end
  end
end
