FactoryGirl.define do
  factory :customer do
    sequence(:first_name) { |n| "First Name#{n}" }
    sequence(:last_name) { |n| "Last Name #{n}" }
  end
end
