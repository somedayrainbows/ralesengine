FactoryGirl.define do
  factory :merchant do
    sequence :name do |n|
      "Merchant #{n}"
      invoices { [association(:invoice)] }
      items { [association(:item)] }
    end
    sequence :created_at do |n|
      "#{n}-03-27 14:53:59 UTC"
    end
    sequence :updated_at do |n|
      "#{n}-07-27 14:54:59 UTC"
    end
  end
end
