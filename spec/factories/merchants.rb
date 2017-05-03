FactoryGirl.define do
  factory :merchant do
    sequence :name do |n|
      "Merchant #{n}"
      invoices { [association(:invoice)] }
      items { [association(:item)] }
    end
  end
end
