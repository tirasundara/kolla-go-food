FactoryGirl.define do
  factory :buyer do
    name "Anugrah"
    email "anugrah@notgg.com"
    phone "08123456"
    address "Planet Mars"
  end

  factory :invalid_buyer, parent: :buyer do
    name nil
    email nil
    phone nil
    address nil
  end
  
end
