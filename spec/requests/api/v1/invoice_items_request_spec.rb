require 'rails_helper'

describe "Invoice items API" do
  it "sends a list of invoice items" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = Item.create!(name: "Hockey puck", description: "lorem ipsum", unit_price: 23, merchant: merchant)
    invoice = Invoice.create!(status: "Paid", merchant: merchant, customer: customer)
    create_list(:invoice_item, 3, item: item, invoice: invoice)

    get '/api/v1/invoice_items'

    expect(response).to be_success

    invoice_items = JSON.parse(response.body)

    expect(invoice_items.count).to eq(3)
  end

  it "can get one invoice item by its id" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = Item.create!(name: "Hockey puck", description: "lorem ipsum", unit_price: 23, merchant: merchant)
    invoice = Invoice.create!(status: "Paid", merchant: merchant, customer: customer)
    item = create_list(:invoice_item, 3, item: item, invoice: invoice).first
    id = item.id

    get "/api/v1/invoice_items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item["id"]).to eq(id)
  end

  it "returns the invoice associated with an invoice item" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice1 = create(:invoice, customer: customer, merchant: merchant)
    invoice2 = create(:invoice, customer: customer, merchant: merchant)
    invoice_item1 = InvoiceItem.create!(item: item, invoice: invoice1)
    invoice_item2 = InvoiceItem.create!(item: item, invoice: invoice2)

    id1 = invoice_item1.id

    get "/api/v1/invoice_items/#{id1}/invoice"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice["id"]).to eq(invoice1.id)
  end

  it "returns the item associated with an invoice item" do
    merchant = create(:merchant)
    customer = create(:customer)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    invoice_item1 = InvoiceItem.create!(item: item1, invoice: invoice)
    invoice_item2 = InvoiceItem.create!(item: item2, invoice: invoice)

    id1 = invoice_item1.id

    get "/api/v1/invoice_items/#{id1}/item"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item["id"]).to eq(item1.id)
  end

  describe 'find endpoints' do
    before :each do
      merchant = create(:merchant)
      customer = create(:customer)
      item1 = create(:item, merchant: merchant, description: 'hi there')
      item2 = create(:item, merchant: merchant, description: 'oh hai')
      invoice1 = create(:invoice, merchant: merchant, customer: customer)
      invoice2 = create(:invoice, merchant: merchant, customer: customer)
      create(:invoice_item, item: item1, invoice: invoice1, quantity: 2, unit_price: 100)
      @invoice_item = create(:invoice_item, item: item2, invoice: invoice2, quantity: 4, unit_price: 4242)
    end

    it "returns a single invoice_item based on an id" do
      get "/api/v1/invoice_items/find?id=#{@invoice_item.id}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint['id']).to eq(@invoice_item.id)
    end

    it "returns a single invoice_item based on a unit_price" do
      get "/api/v1/invoice_items/find?unit_price=42.42"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint['id']).to eq(@invoice_item.id)
    end

    it "returns a single invoice_item based on a quantity" do
      get "/api/v1/invoice_items/find?quantity=#{@invoice_item.quantity}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint['id']).to eq(@invoice_item.id)
    end

    it "returns a single invoice_item based on an item_id" do
      get "/api/v1/invoice_items/find?item_id=#{@invoice_item.item_id}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint['id']).to eq(@invoice_item.id)
    end

    it "returns a single invoice_item based on an invoice_id" do
      get "/api/v1/invoice_items/find?invoice_id=#{@invoice_item.invoice_id}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint['id']).to eq(@invoice_item.id)
    end

    it "returns a single invoice_item based on a created date" do
      get "/api/v1/invoice_items/find?created_at=#{@invoice_item.created_at}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint['id']).to eq(@invoice_item.id)
    end

    it "returns a single invoice_item based on updated date" do
      get "/api/v1/invoice_items/find?updated_at=#{@invoice_item.updated_at}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint['id']).to eq(@invoice_item.id)
    end
  end

  describe 'find_all endpoints' do
    before :each do
      merchant = create(:merchant)
      customer = create(:customer)
      item1 = create(:item, merchant: merchant, description: 'hi there')
      item2 = create(:item, merchant: merchant, description: 'oh hai')
      invoice1 = create(:invoice, merchant: merchant, customer: customer)
      invoice2 = create(:invoice, merchant: merchant, customer: customer)
      @invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 2, unit_price: 100)
      @invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 4, unit_price: 4242)
    end

    it "returns a collection of invoice_items based on an id" do
      get "/api/v1/invoice_items/find_all?id=#{@invoice_item1.id}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint.first['id']).to eq(@invoice_item1.id)
    end

    it "returns a collection of invoice_items based on a quantity" do
      get "/api/v1/invoice_items/find_all?quantity=#{@invoice_item1.quantity}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint.count).to eq(1)
      expect(invoice_item_endpoint.first['id']).to eq(@invoice_item1.id)
    end

    it "returns a collection of invoice_items based on a unit_price" do
      get "/api/v1/invoice_items/find_all?unit_price=#{@invoice_item1.unit_price.to_f/100}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint.count).to eq(1)
      expect(invoice_item_endpoint.first['id']).to eq(@invoice_item1.id)
    end

    it "returns a collection of invoice_items based on an item_id" do
      get "/api/v1/invoice_items/find_all?item_id=#{@invoice_item1.item_id}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint.count).to eq(1)
      expect(invoice_item_endpoint.first['id']).to eq(@invoice_item1.id)
    end

    it "returns a collection of invoice_items based on an invoice_id" do
      get "/api/v1/invoice_items/find_all?invoice_id=#{@invoice_item1.invoice_id}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint.count).to eq(1)
      expect(invoice_item_endpoint.first['id']).to eq(@invoice_item1.id)
    end

    it "returns a collection of invoice_items based on a created date" do
      get "/api/v1/invoice_items/find_all?created_at=#{@invoice_item1.created_at}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint.count).to eq(1)
      expect(invoice_item_endpoint.first['id']).to eq(@invoice_item1.id)
    end

    it "returns a collection of invoice_items based on updated date" do
      get "/api/v1/invoice_items/find_all?updated_at=#{@invoice_item2.updated_at}"

      invoice_item_endpoint = JSON.parse(response.body)

      expect(invoice_item_endpoint.count).to eq(1)
      expect(invoice_item_endpoint.first['id']).to eq(@invoice_item2.id)
    end
  end

  describe 'find random' do
    it "returns a random invoice_item" do
      merchant = create(:merchant)
      customer = create(:customer)
      item1 = create(:item, merchant: merchant, description: 'hi there')
      item2 = create(:item, merchant: merchant, description: 'oh hai')
      invoice1 = create(:invoice, merchant: merchant, customer: customer)
      invoice2 = create(:invoice, merchant: merchant, customer: customer)
      create(:invoice_item, item: item1, invoice: invoice1, quantity: 2, unit_price: 100)
      create(:invoice_item, item: item2, invoice: invoice2, quantity: 4, unit_price: 42)

      get "/api/v1/invoice_items/random"

      JSON.parse(response.body)

      expect(response).to be_success
    end
  end
end
