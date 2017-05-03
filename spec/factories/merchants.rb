FactoryGirl.define do
  factory :merchant do
    sequence :name do |n|
      "Merchant #{n}"
      invoices { [association(:invoice)] }
      items { [association(:invoice)] }
    end
  end
end
