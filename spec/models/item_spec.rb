require 'rails_helper'

RSpec.describe Item, type: :model do
  context "relationships" do
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices) }
    it { should belong_to(:merchant) }
  end
end
