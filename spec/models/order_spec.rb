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
    order = build(:order, address: nil)
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
   expect(order.total_price).to eq(50000.0)
  end
end
