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
end
