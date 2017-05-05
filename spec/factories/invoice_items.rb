FactoryGirl.define do
  factory :invoice_item do
    quantity 2
    unit_price 1000
    sequence :created_at do |n|
      "#{n}-05-27 14:53:59 UTC"
    end
    sequence :updated_at do |n|
      "#{n}-02-27 14:54:59 UTC"
    end
  end
end
