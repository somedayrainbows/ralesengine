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

  it "returns a collection of items associated with that merchant" do # GET /api/v1/merchants/:id/items
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

  it "returns a collection of invoices associated with that merchant from their known orders" do # GET /api/v1/merchants/:id/invoices
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
end
