# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "kategori#{n}"
    end
  end

  factory :invalid_category, parent: :category do
    name nil
  end
end
