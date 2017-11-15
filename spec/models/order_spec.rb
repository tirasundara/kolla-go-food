require 'rails_helper'

describe Order do
  it "has a valid factory" do
    expect(build(:order)).to be_valid
  end

  it "is valid with a name, address, email, and payment_type" do
    order = build(:order)
    expect(order).to be_valid
  end

  it "is invalid without a name" do
    order = build(:order, name: nil)
    order.valid?
    expect(order.errors[:name]).to include("can't be blank")
  end

  it "is invalid without an address" do
    order = build(:order, address: "")
    order.valid?
    expect(order.errors[:address]).to include("can't be blank")
  end

  it "is invalid without an email" do
    order = build(:order, email: nil)
    order.valid?
    expect(order.errors[:email]).to include("can't be blank")
  end

  it "is invalid with email not in valid email format" do
    order = build(:order, email: 'tes_email')
    order.valid?
    expect(order.errors[:email]).to include("email format is invalid")
  end

  it "is invalid without payment_type" do
    order = build(:order, payment_type: nil)
    order.valid?
    expect(order.errors[:payment_type]).to include("can't be blank")
  end

  it "is invalid with wrong payment_type" do
    expect{ build(:order, payment_type: "Grab Pay") }.to raise_error(ArgumentError)
  end

  describe "adding line_items from cart" do
    before :each do
      @cart = create(:cart)
      @line_item = create(:line_item, cart: @cart)
      @order = build(:order)
    end
    it "add line_items to order" do
      expect {
        @order.add_line_items(@cart)
        @order.save
      }.to change(@order.line_items, :count).by(1)
    end
    it "removes line_items from cart" do
      expect {
        @order.add_line_items(@cart)
        @order.save
      }.to change(@cart.line_items, :count).by(-1)
    end
  end

  it "can calculate total_price" do
   cart = create(:cart)
   food1 = create(:food, price: 20000.00)
   food2 = create(:food, price: 5000.00)
   line_item1 = create(:line_item, cart: cart, food: food1, quantity: 2)
   line_item2 = create(:line_item, cart: cart, food: food2, quantity: 2)
   order = create(:order, line_items: [line_item1, line_item2])
   expect(order.sub_total_price).to eq(50000.0)
  end

  describe "adding voucher" do
    before :each do
      @cart = create(:cart)
      @food1 = create(:food, price: 20000.00)
      @food2 = create(:food, price: 5000.00)
      @line_item1 = create(:line_item, cart: @cart, food: @food1, quantity: 2)
      @line_item2 = create(:line_item, cart: @cart, food: @food2, quantity: 2)
      @voucher1 = create(:voucher, unit: 1, amount: 100000.00, max_amount: 110000.00)
      @voucher2 = create(:voucher, code: "disc", unit: 0, amount: 20.00, max_amount: 10000.0)
      @expired_voucher = create(:voucher, code: "expired_lol",valid_from:"2017-09-01 21:00:00", valid_through:"2017-10-01 21:00:00", unit: "percent", amount: 90.00, max_amount: 990000.00)
    end
    context "unit = IDR" do
      it "can calculate IDR discount" do
        order = create(:order, line_items: [@line_item1, @line_item2],  voucher: @voucher1)
        expect(order.calculate_discount).to eq(100000.0)
      end
    end
    context "unit = %" do
      it "can calculate percentage discount" do
        order = create(:order, line_items: [@line_item1, @line_item2],  voucher: @voucher2)
        expect(order.calculate_discount).to eq(10000.00)
      end
    end

    context "when total_price_after_discount <= 0" do
      it "can calculate total price after discount" do
        order = build(:order, line_items: [@line_item1, @line_item2],  voucher: @voucher1)
        order.address = "Wisma NAELAH"
        order.origin = "Monas"
        expect(order.total_price_after_discount).to eq(0.00)
      end
    end
    # context "when the voucher is expired" do
    #   it "returns the normal total price (without disc)" do
    #     order = create(:order, line_items: [@line_item1, @line_item2],  voucher: @expired_voucher)
    #     expect(order.total_price_after_discount).to eq(50000.0)
    #   end
    # end
    # it "returns nil if voucher can't be used yet"
  end

  describe "Google maps API" do
    before :each do
      @order = build(:order)
      @order.origin = "Monas"
      @order.address = "Sarinah"
      @price_per_km = 1500.0
    end

    context "with valid address" do
      it "returns distance in km" do
        expect(@order.get_distance).to eq(1.5)
      end

      it "can calculate delivery cost" do
        expect(@order.delivery_cost).to eq(2250.0)
      end

      it "can calculate sum of total_price and delivery_cost" do
        cart = create(:cart)
        food = create(:food, price: 20000.00)
        line_item = create(:line_item, cart: cart, food: food)
        order = build(:order, line_items: [line_item])
        order.origin = "Monas"
        order.address = "Sarinah"
        expect(order.total_price_after_discount).to eq(22250.0)
      end
    end

    it "is invalid with unknown address" do
      order = build(:order, address: "xyz")
      order.valid?
      expect(order.errors[:address]).to include("is invalid")
    end
  end
end
