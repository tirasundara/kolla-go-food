FactoryGirl.define do
  factory :food do
    name {Faker::Food.dish}
    description "nasi bla bla"
    price 10000.0
    image_url "nasi_kuning.png"

    association :category
  end

  factory :invalid_food, parent: :food do
    name nil
    description nil
    price 10000.0
  end
end
