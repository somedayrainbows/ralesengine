require 'rails_helper'

RSpec.describe Customer, type: :model do
  context "relationships" do
    it { should have_many(:invoices) }
  end
end
