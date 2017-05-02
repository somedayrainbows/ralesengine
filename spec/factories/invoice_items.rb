FactoryGirl.define do
  factory :invoice_item do
    sequence(:quantity) { |n| "#{n}" }
    sequence(:unit_price) { |n| "#{n}" }
  end
end
