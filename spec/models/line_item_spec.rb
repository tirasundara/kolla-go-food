require 'rails_helper'

describe LineItem do
  it "has a valid factory" do
    expect(build(:line_item)).to be_valid
  end

  it "deletes line_items when deleted" do
    cart = create(:cart)
    food1 = create(:food)
    food2 = create(:food)

    line_item1 = create(:line_item, cart: cart, food: food1)
    line_item2 = create(:line_item, cart: cart, food: food2)
    cart.line_items << line_item1
    cart.line_items << line_item2

    expect { cart.destroy }.to change { LineItem.count }.by(-2)
  end

  # it "can calculate total_price" do
  #  cart = create(:cart)
  #  food1 = create(:food)
  #  food2 = create(:food, price: 5000)
  #  line_item2 = create(:line_item, cart: cart, food: food2, quantity: 4)

  #  expect(line_item2.total_price.to_f).to eq(20000.0) #  .to_f biar float nya gak pake notasi e
  # end
end
