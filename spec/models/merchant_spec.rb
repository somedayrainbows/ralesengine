require 'rails_helper'

RSpec.describe Merchant, type: :model do
  context "relationships" do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end

  it "returns revenue for a merchant" do
    customer = create(:customer)
    merchant = create(:merchant, name: 'Billy Bob Bacon')
    invoice = create(:invoice, merchant: merchant, customer: customer)
    items = create_list(:item, 2, merchant: merchant)
    InvoiceItem.create(invoice: invoice, item: items.first, unit_price: 1000, quantity: 2)
    InvoiceItem.create(invoice: invoice, item: items.second, unit_price: 2500, quantity: 3)
    create(:transaction, invoice: invoice)

    expect(Merchant.find(merchant.id).revenue).to eq("95.0")
  end

  it "returns revenue for a merchant" do
    customer = create(:customer)
    merchant = create(:merchant, name: 'Billy Bob Bacon')
    invoice = create(:invoice, merchant: merchant, customer: customer)
    items = create_list(:item, 2, merchant: merchant)
    InvoiceItem.create(invoice: invoice, item: items.first, unit_price: 1000, quantity: 2)
    InvoiceItem.create(invoice: invoice, item: items.second, unit_price: 2500, quantity: 3)
    create(:transaction, invoice: invoice)

    expect(Merchant.find(merchant.id).revenue).to eq("95.0")
  end
end
