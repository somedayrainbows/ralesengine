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
end
