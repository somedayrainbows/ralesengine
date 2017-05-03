require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context "relationships" do
    it { should belong_to(:invoice) }
  end
end
