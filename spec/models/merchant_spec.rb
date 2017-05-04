require 'rails_helper'

RSpec.describe Merchant, type: :model do
  context "relationships" do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end

  it "it returns customers with pending invoices for a single merchant" do
    merchant1 = create(:merchant)
    customer = create(:customer)
    merchant2 = create(:merchant)
    invoices = create_list(:invoice, 5, merchant: merchant1, customer: customer)
    invoices.first.update_attributes(status: "Pending")
    invoices.last.update_attributes(status: "Pending")

  end
end
