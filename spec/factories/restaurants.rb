# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :restaurant do
    name "RM Raja Roso"
    address "Jl. In aja"
  end
  factory :invalid_restaurant, parent: :restaurant do
    name nil
    address nil
  end
end
