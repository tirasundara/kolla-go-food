FactoryGirl.define do
  factory :line_item do
    association :food
    association :cart
  end
end
