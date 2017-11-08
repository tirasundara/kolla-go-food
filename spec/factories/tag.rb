# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    name "pedas"
  end
  factory :invalid_tag, parent: :tag do
    name nil
  end
end
