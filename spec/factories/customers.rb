FactoryGirl.define do
  factory :customer do
    sequence(:first_name) { |n| "First Name#{n}" }
    sequence(:last_name) { |n| "Last Name #{n}" }
    sequence :created_at do |n|
      "#{n}-05-27 14:53:59 UTC"
    end
    sequence :updated_at do |n|
      "#{n}-02-27 14:54:59 UTC"
    end
  end
end
