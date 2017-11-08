FactoryGirl.define do
  factory :food do
    association :category
    association :tag
    sequence :name do |n|
      "food#{n}"
    end
    description "nasi bla bla"
    price 10000.0
    image_url "nasi_kuning.png"
  end

  factory :invalid_food, parent: :food do
    name nil
    description nil
    price 10000.0
  end
end
