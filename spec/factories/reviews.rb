# # Read about factories at https://github.com/thoughtbot/factory_girl
#
# FactoryGirl.define do
#   factory :review do
#     name "MyString"
#     title "MyString"
#     description "MyText"
#     reviewable_id 1
#     reviewable_type "MyString"
#   end
# end

FactoryGirl.define do
  factory :food_review, class: "Review" do
    name { Faker::Name.first_name }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :reviewable, factory: :food
  end

  factory :invalid_food_review, parent: :food_review do
    name nil
    title nil
    description nil
    reviewable nil
  end

  factory :restaurant_review, class: "Review" do
    name { Faker::Name.first_name }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :reviewable, factory: :restaurant
  end

  factory :invalid_restaurant_review, parent: :restaurant_review do
    name nil
    title nil
    description nil
    reviewable nil
  end
end
