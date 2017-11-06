require 'rails_helper'

RSpec.describe Voucher, type: :model do
  it "has a valid factory" do
    expect(build(:voucher)).to be_valid
  end
  it "is valid with a code, valid_from, valid_through, amount, unit, and max_amount" do
    voucher = build(:voucher)
    expect(voucher).to be_valid
  end

  it "is invalid without a code" do
    voucher = build(:voucher, code: nil)
    voucher.valid?
    expect(voucher.errors[:code]).to include("can't be blank")
  end

  it "is uppercase" do
    voucher = build(:voucher, code: 'hello')
    voucher.valid?
    expect(voucher[:code]).to eq('HELLO')
  end

  it "is invalid without a valid_from" do
    voucher = build(:voucher, valid_from: nil)
    voucher.valid?
    expect(voucher.errors[:valid_from]).to include("can't be blank")
  end

  it "is invalid without a valid_through" do
    voucher = build(:voucher, valid_through: nil)
    voucher.valid?
    expect(voucher.errors[:valid_through]).to include("can't be blank")
  end

  it "is invalid without an amount" do
    voucher = build(:voucher, amount: nil)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("can't be blank")
  end

  it "is invalid without a unit" do
    voucher = build(:voucher, unit: nil)
    voucher.valid?
    expect(voucher.errors[:unit]).to include("can't be blank")
  end

  it "is invalid without a max_amount" do
    voucher = build(:voucher, max_amount: nil)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("can't be blank")
  end

  it "is invalid with non-numerical values (amount)" do
    voucher = build(:voucher, amount: '123hallo')
    voucher.valid?
    expect(voucher.errors[:amount]).to include("is not a number")
  end

  it "is invalid with non-numerical values (max_amount)" do
    voucher = build(:voucher, max_amount: '123hallo')
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("is not a number")
  end


  it "is invalid if price less than 0.01 (amount)" do
    voucher = build(:voucher, amount: 0.0)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("must be greater than or equal to 0.01")
  end

  it "is invalid if price less than 0.01 (amount)" do
    voucher = build(:voucher, max_amount: 0.0)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("must be greater than or equal to 0.01")
  end
end
