require 'rails_helper'

RSpec.describe Merchant, type: :model do
  context "relationships" do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end

  it "returns a single merchant based on any merchant attributes and is case insensitive" do #single finder for /find?name=params  -id, name, created_at, updated_at
    merchant = create(:merchant)
  end


  it "returns all merchants based on any merchant attributes and is case insensitive" do # multi-finder for /find_all?name=params  -id, name, created_at, updated_at
    merchant1 = Merchant.create!(name: "Jack Black")
    merchant3 = Merchant.create!(name: "Jane Black")
    merchant3 = Merchant.create!(name: "Jack Velendez")
    merchant4 = Merchant.create!(name: "Jane Sauro")
    # merchants = create_list(:merchant, 5)

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
