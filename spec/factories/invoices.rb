FactoryGirl.define do
  factory :invoice do
    sequence(:status) { |n| "#{n} status" }
  end
end
