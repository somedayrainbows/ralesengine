require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = Merchant.create!(name: 'Lady Jane')
    items = create_list(:item, 3, merchant: merchant)

    get '/api/v1/items'

    expect(response).to be_success

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end

  it "can get one item by its id" do
    merchant = Merchant.create!(name: 'Lady Jane')
    item = create_list(:item, 3, merchant: merchant).first
    id = item.id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item["id"]).to eq(id)
  end

  it "returns a collection of associated invoice items" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    invoice_items1 = create_list(:invoice_item, 3, item: item1, invoice: invoice)
    invoice_items2 = create_list(:invoice_item, 3, item: item2, invoice: invoice)
    id = item1.id

    get "/api/v1/items/#{id}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_items.count).to eq(invoice_items1.count)
    expect(invoice_items.first["id"]).to eq(invoice_items1.first.id)
  end

  it "returns the associated merchant" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    items = create_list(:item, 3, merchant: merchant1)
    id = items.first.id
    get "/api/v1/items/#{id}/merchant"
    merchant = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.first.merchant).to eq(merchant1)
    expect(items.first.merchant).to_not eq(merchant2)
  end

  describe 'find endpoints' do
    before :each do
      merchant = create(:merchant)
      create(:item, merchant: merchant, description: 'hi there')
      @item = create(:item, merchant: merchant, description: 'oh hai')
    end

    it "returns a single item based on an id" do
      get "/api/v1/items/find?id=#{@item.id}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint['id']).to eq(@item.id)
    end

    it "returns a single item based on a name" do
      get "/api/v1/items/find?name=#{@item.name}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint['id']).to eq(@item.id)
    end

    it "returns a single item based on a description" do
      get "/api/v1/items/find?description=#{@item.description}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint['id']).to eq(@item.id)
    end

    it "returns a single item based on a name" do
      get "/api/v1/items/find?unit_price=#{@item.unit_price}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint['id']).to eq(@item.id)
    end

    it "returns a single item based on a created date" do
      get "/api/v1/items/find?created_at=#{@item.created_at}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint['id']).to eq(@item.id)
    end

    it "returns a single item based on updated date" do
      get "/api/v1/items/find?updated_at=#{@item.updated_at}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint['id']).to eq(@item.id)
    end
  end

  describe 'find_all endpoints' do
    before :each do
      merchant = create(:merchant)
      @item1 = Item.create!(name: 'table',
                            unit_price: 100,
                            description: 'hi',
                            created_at: "2000-03-27 14:53:59 UTC",
                            updated_at: "2009-03-27 14:53:59 UTC",
                            merchant: merchant)
      @item2 = Item.create!(name: 'table',
                            unit_price: 100,
                            description: 'hi',
                            created_at: "2003-03-27 14:53:59 UTC",
                            updated_at: "2005-03-27 14:53:59 UTC",
                            merchant: merchant)
      @item3 = Item.create!(name: 'chair',
                            unit_price: 200,
                            description: 'hello',
                            created_at: "2004-03-27 14:53:59 UTC",
                            updated_at: "2005-03-27 14:53:59 UTC",
                            merchant: merchant)
      @item4 = Item.create!(name: 'chair',
                            unit_price: 200,
                            description: 'hello',
                            created_at: "2000-03-27 14:53:59 UTC",
                            updated_at: "2032-03-27 14:53:59 UTC",
                            merchant: merchant)
    end

    it "returns a collection of items based on an id" do
      get "/api/v1/items/find_all?id=#{@item1.id}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint.first['id']).to eq(@item1.id)
    end

    it "returns a collection of items based on a name" do
      get "/api/v1/items/find_all?name=#{@item1.name}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint.count).to eq(2)
      expect(item_endpoint.first['id']).to eq(@item1.id)
    end

    it "returns a collection of items based on a unit_price" do
      get "/api/v1/items/find_all?unit_price=#{@item1.unit_price}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint.count).to eq(2)
      expect(item_endpoint.first['id']).to eq(@item1.id)
    end

    it "returns a collection of items based on a description" do
      get "/api/v1/items/find_all?description=#{@item1.description}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint.count).to eq(2)
      expect(item_endpoint.first['id']).to eq(@item1.id)
    end

    it "returns a collection of items based on a created date" do
      get "/api/v1/items/find_all?created_at=#{@item1.created_at}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint.count).to eq(2)
      expect(item_endpoint.first['id']).to eq(@item1.id)
      expect(item_endpoint.last['id']).to eq(@item4.id)
    end

    it "returns a collection of items based on updated date" do
      get "/api/v1/items/find_all?updated_at=#{@item2.updated_at}"

      item_endpoint = JSON.parse(response.body)

      expect(item_endpoint.count).to eq(2)
      expect(item_endpoint.first['id']).to eq(@item2.id)
      expect(item_endpoint.last['id']).to eq(@item3.id)
    end
  end

  describe 'find random' do
    it "returns a random item" do
      merchant = create(:merchant)
      create(:item, name: 'Seashell', merchant: merchant)
      create(:item, name: 'Bacon', merchant: merchant)

      get "/api/v1/items/random"

      JSON.parse(response.body)

      expect(response).to be_success
    end
  end

  describe "business intelligence"do
    it "returns an items best day" do
      customer1 = create(:customer)
      merchant1 = create(:merchant, name: 'Billy Bobs Bacon')
      item1 = create(:item, merchant: merchant1)
      invoice1 = create(:invoice, created_at: "2000-03-27 14:53:59 UTC", merchant: merchant1, customer: customer1)
      invoice2 = create(:invoice, created_at: "2001-03-27 14:53:59 UTC", merchant: merchant1, customer: customer1)
      invoice3 = create(:invoice, created_at: "2002-03-27 14:53:59 UTC", merchant: merchant1, customer: customer1)
      invoice4 = create(:invoice, created_at: "2003-03-27 14:53:59 UTC", merchant: merchant1, customer: customer1)
      InvoiceItem.create(invoice: invoice1, item: item1, quantity: 4)
      InvoiceItem.create(invoice: invoice2, item: item1, quantity: 4)
      InvoiceItem.create(invoice: invoice3, item: item1, quantity: 1)
      InvoiceItem.create(invoice: invoice4, item: item1, quantity: 4)
      create(:transaction, invoice: invoice1, result: 'success')
      create(:transaction, invoice: invoice2, result: 'success')
      create(:transaction, invoice: invoice3, result: 'success')
      create(:transaction, invoice: invoice4, result: 'failed')
      id = item1.id

      get "/api/v1/items/#{id}/best_day"

      endpoint_day = JSON.parse(response.body)

      expect(endpoint_day["best_day"]).to eq("2001-03-27T14:53:59.000Z")
    end

    it "returns the top items ranked by total sold" do
      customer = create(:customer)
      merchant = create(:merchant, name: 'Billy Bobs Bacon')
      invoice1 = create(:invoice, merchant: merchant, customer: customer)
      invoice2 = create(:invoice, merchant: merchant, customer: customer)
      invoice3 = create(:invoice, merchant: merchant, customer: customer)
      invoice4 = create(:invoice, merchant: merchant, customer: customer)
      items = create_list(:item, 6, merchant: merchant)
      InvoiceItem.create(invoice: invoice1, item: items[0], quantity: 10)
      InvoiceItem.create(invoice: invoice2, item: items[1], quantity: 30)
      InvoiceItem.create(invoice: invoice3, item: items[2], quantity: 40)
      InvoiceItem.create(invoice: invoice4, item: items[3], quantity: 20)
      InvoiceItem.create(invoice: invoice4, item: items[4], quantity: 5)
      InvoiceItem.create(invoice: invoice1, item: items[5], quantity: 50)
      create(:transaction, invoice: invoice1)
      create(:transaction, invoice: invoice2)
      create(:transaction, invoice: invoice3)
      create(:transaction, invoice: invoice4)

      get "/api/v1/items/most_items?quantity=4"

      endpoint_items = JSON.parse(response.body)

      expect(endpoint_items.count).to eq(4)
      expect(endpoint_items.first['id']).to eq(items[5].id)
      expect(endpoint_items.second['id']).to eq(items[2].id)
      expect(endpoint_items.third['id']).to eq(items[1].id)
      expect(endpoint_items.fourth['id']).to eq(items[3].id)
      expect(endpoint_items.first['items_sold']).to eq(50)
      expect(endpoint_items.second['items_sold']).to eq(40)
      expect(endpoint_items.third['items_sold']).to eq(30)
      expect(endpoint_items.fourth['items_sold']).to eq(20)
    end
  end

  it "returns top x items ranked by revenue" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice1 = create(:invoice, merchant: merchant, customer: customer)
    invoice2 = create(:invoice, merchant: merchant, customer: customer)
    invoice3 = create(:invoice, merchant: merchant, customer: customer)
    invoice4 = create(:invoice, merchant: merchant, customer: customer)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    item4 = create(:item, merchant: merchant)
    InvoiceItem.create!(invoice: invoice1, item: item1, quantity: 5, unit_price: 345)
    InvoiceItem.create!(invoice: invoice2, item: item2, quantity: 10, unit_price: 345)
    InvoiceItem.create!(invoice: invoice3, item: item3, quantity: 45, unit_price: 345)
    InvoiceItem.create!(invoice: invoice4, item: item4, quantity: 2, unit_price: 345)
    create(:transaction, invoice: invoice1)
    create(:transaction, invoice: invoice2)
    create(:transaction, invoice: invoice3)
    create(:transaction, invoice: invoice4)

    get "/api/v1/items/most_revenue?quantity=5"

    item_endpoint = JSON.parse(response.body)
    expect(response).to be_success
    expect(item_endpoint.count).to eq(4)
    expect(item_endpoint.first['name']).to eq(item3.name)
    expect(item_endpoint.second['name']).to eq(item2.name)
    expect(item_endpoint.third['name']).to eq(item1.name)


  end
end
