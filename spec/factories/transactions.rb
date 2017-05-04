FactoryGirl.define do
  factory :transaction do
    credit_card_number 123
    result "success"
    sequence :created_at do |n|
      "#{n}-03-27 14:53:59 UTC"
    end
    sequence :updated_at do |n|
      "#{n}-07-27 14:54:59 UTC"
    end
  end
end
