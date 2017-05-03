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
end
