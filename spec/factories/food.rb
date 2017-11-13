# FactoryGirl.define do
#   factory :food do
#     association :category
#     # association :tag
#     association :restaurant
#     # tag_ids {[]}
#     sequence :name do |n|
#       "food#{n}"
#     end
#     description "nasi bla bla"
#     price 10000.0
#     image_url "nasi_kuning.png"
#     # restaurant_id 3
#   end
#
#   factory :invalid_food, parent: :food do
#     name nil
#     description nil
#     price 10000.0
#   end
# end

FactoryGirl.define do
  factory :food do
    sequence(:name) { |n| "Food-#{n}" }
    description { Faker::Food.ingredient }
    image_url "Food.jpg"
    price 10000.0
    association :category
    association :restaurant
  end

  factory :invalid_food, parent: :food do
    name nil
    description nil
    price 10000.0
  end
end
