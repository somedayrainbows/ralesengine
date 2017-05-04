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

  describe 'find endpoints'do
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
      merchant1 = create(:merchant, name: 'Sallys Seashells')
      merchant2 = create(:merchant, name: 'Billy Bob Bacon')

      get "/api/v1/merchants/random"

      merchant_endpoint = JSON.parse(response.body)

      expect(response).to be_success
    end
  end
end
