FactoryGirl.define do
  factory :order do
    name { Faker::Name.name }
    address "Monas"
    email { Faker::Internet.email }
    payment_type "Go Pay"
  end
  factory :invalid_order, parent: :order do
    name nil
    address nil
    email nil
    payment_type nil
  end
end
