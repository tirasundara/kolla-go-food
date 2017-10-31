# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :drink do
    association :category
    name "Coca Cola"
    description "Danger sugar water?"
    image_url "coca_cola.png"
    price 5000.00
  end

  factory :invalid_drink, parent: :drink do
    name nil
    description nil
    price nil
  end
end
