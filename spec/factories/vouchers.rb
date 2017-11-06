# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voucher do
    code "MyString"
    valid_from "2017-11-06 13:24:16"
    valid_through "2017-11-30 13:24:16"
    amount "9.99"
    unit 1
    max_amount "9.99"
  end

  factory :invalid_voucher, parent: :voucher do
    code nil
    valid_from nil
    valid_through nil
    amount nil
    unit nil
    max_amount nil
  end
end
