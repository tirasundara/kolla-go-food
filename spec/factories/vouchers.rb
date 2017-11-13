# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voucher do
    code "HEMAT10K"
    valid_from "2017-11-01 13:24:16"
    valid_through "2017-12-31 23:59:59"
    amount "10000.00"
    unit "percent"
    max_amount "10000.00"
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
