FactoryGirl.define do
  factory :line_item do
    association :food
    association :cart
    quantity 1
  end
end
