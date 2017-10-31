require 'rails_helper'

RSpec.describe Cart, type: :model do
  before :each do
    @food = create(:food, name: 'Sama')
    @cart = Cart.new
  end
  # pending "add some examples to (or delete) #{__FILE__}"
  it "does not change the number of line item if the same food is added" do
    cart = create(:cart)
    food = create(:food, name: 'Nasi Uduk')
    line_item = create(:line_item, food: food, cart: cart)
    expect { cart.add_food(food) }.not_to change(LineItem, :count)
  end
  it "increment the qty of line_item if the same food is added" do
    cart = create(:cart)
    food = create(:food, name: 'Nasi Uduk')
    line_item = create(:line_item, food: food, cart: cart)
    expect(cart.add_food(food).quantity).to eq(2)
    #expect { cart.add_food(food) }.to change(line_item.quantity, :count)
  end

  it "returns total_price as sum of items price" do
    cart = create(:cart)
    food1 = create(:food)
    food2 = create(:food, price: 5000)

    line_item1 = create(:line_item, cart: cart, food: food1, quantity: 2)
    line_item2 = create(:line_item, cart: cart, food: food2, quantity: 4)

    expect(cart.total_price.to_f).to eq(40000.0) #  .to_f biar float nya gak pake notasi e
  end
end
