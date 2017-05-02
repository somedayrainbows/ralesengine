FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "#{n} name"}
    description "This item is wonderful and innovative and has been featured on the Home Shopping Network numerous times!"
    sequence(:unit_price) { |n| "#{n} unit_price"}
  end
end
