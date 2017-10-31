FactoryGirl.define do
  factory :line_item do
    association :food
    association :drink
    association :cart
    quantity 1
  end
end
