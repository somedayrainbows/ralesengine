require 'rails_helper'

RSpec.describe Merchant, type: :model do
  context "relationships" do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end
end

  # context 'relationships' do
  #     it 'has many invoices' do
  #       merchant = Merchant.create(name: 'Lady Jane')
  #
  #       invoices = create_list(:invoice, 2, merchant: merchant)
  #       merchant.invoices << invoices
  #
  #       expect(merchant.invoices).to eq(invoices)
  #     end
  #   end
