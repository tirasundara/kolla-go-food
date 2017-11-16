FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "Role-#{n}" }
  end

  factory :invalid_role, parent: :role do
    name nil
  end

end
