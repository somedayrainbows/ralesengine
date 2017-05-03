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
end
