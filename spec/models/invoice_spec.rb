require 'rails_helper'

RSpec.describe Invoice, type: :model do
  context "relationships" do
    it { should have_many(:transactions) }
    it { should belong_to(:merchant) }
    it { should belong_to(:customer) }
  end
end
