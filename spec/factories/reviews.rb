# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    name "MyString"
    title "MyString"
    description "MyText"
    reviewable_id 1
    reviewable_type "MyString"
  end
end
