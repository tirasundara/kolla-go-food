# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :restaurant do
    sequence :name do |n|
      "Restaurant #{n}"
    end
    sequence :address do |x|
      "Jl. In aja #{x}"
    end

  end
  factory :invalid_restaurant, parent: :restaurant do
    name nil
    address nil
  end
end
