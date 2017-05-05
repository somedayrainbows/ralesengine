FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "#{n} name"}
    description "This item is wonderful and innovative and has been featured on the Home Shopping Network numerous times!"
    sequence(:unit_price) { |n| "#{n} unit_price"}
    sequence :created_at do |n|
      "#{n}-03-27 14:53:59 UTC"
    end
    sequence :updated_at do |n|
      "#{n}-07-27 14:54:59 UTC"
    end
  end
end
