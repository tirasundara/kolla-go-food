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

  it "saves code with UPPERCASE letter" do
    voucher = create(:voucher, code: 'hello')
    expect(voucher[:code]).to eq('HELLO')
  end

  it "is invalid with case-insensitive duplicate code" do
    voucher1 = create(:voucher, code: "CODE")
    voucher2 = build(:voucher, code: "code")
    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
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

  it "is invalid with wrong unit" do
    expect{ build(:voucher, unit: 3) }.to raise_error(ArgumentError)
  end

  it "is invalid without a max_amount" do
    voucher = build(:voucher, max_amount: nil)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("can't be blank")
  end

  it "is invalid with a duplicate code" do
    voucher1 = create(:voucher, code: "disc10k")
    voucher2 = build(:voucher, code: "disc10k")
    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
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

  it "is invalid if amount less than 0.01 (amount)" do
    voucher = build(:voucher, amount: 0.0)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("must be greater than or equal to 0.01")
  end

  it "is invalid if price less than 0.01 (amount)" do
    voucher = build(:voucher, max_amount: 0.0)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("must be greater than or equal to 0.01")
  end

  it "can't be destroyed while it has order(s)" do
    voucher = create(:voucher)
    order = create(:order, voucher: voucher)
    expect { voucher.destroy }.not_to change(Voucher, :count)
  end

  context "with unit value is IDR" do
    it "is invalid with max_amount less than amount" do
      voucher = build(:voucher, unit: 1, amount: 5000.0, max_amount: 3000.0)
      voucher.valid?
      # puts voucher.errors.messages
      expect(voucher.errors[:max_amount]).to include("must be greater or equal to amount")
    end
  end

  describe "Check voucher validity and availability" do
    it "invalid if valid_through < valid_from" do
      voucher = build(:voucher, valid_from: "2017-11-01 00:00:01", valid_through: "2017-10-01 00:00:01")
      voucher.valid?
      expect(voucher.errors[:valid_through]).to include("must be greater than or equal to valid_from")
    end
    context "not expired voucher" do
      it "is not expired if (today's date <= valid_through && today's date >= valid_from)" do
        voucher = create(:voucher, valid_from: "2017-11-01 00:00:01", valid_through: "2017-12-31 23:59:59")
        expect(voucher.not_expired?).to eq(true)
      end
    end

    # context "availability voucher" do
    #   it "returns true if voucher is available" do
    #     voucher = create(:voucher, code: "DISC10%")
    #     expect(Voucher.avail_voucher?("DISC10%")).to eq(true)
    #   end
    #   it "returns false if voucher is not available" do
    #     expect(Voucher.avail_voucher?("nothing")).to eq(false)
    #   end
    # end
    # context "get voucher_id" do
    #   it "does not return nil" do
    #     voucher = create(:voucher, code: "DISC10%")
    #     expect(Voucher.get_voucher_id("DISC10%")).not_to eq(nil)
    #   end
    # end
  end

end
