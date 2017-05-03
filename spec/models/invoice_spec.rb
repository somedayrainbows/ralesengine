require 'rails_helper'

RSpec.describe Invoice, type: :model do
  context "relationships" do
    it { should have_many(:transactions) }
  end
end
