require 'rails_helper'

describe Drink do
  it "has a valid factory" do
    expect(build(:drink)).to be_valid
  end

  it "invalid without a name" do
    drink = build(:drink, name: nil)
    drink.valid?
    expect(drink.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    drink1 = create(:drink, name: 'Sprite')
    drink2 = build(:drink, name: 'Sprite')
    drink2.valid?
    expect(drink2.errors[:name]).to include("has already been taken")
  end

  it "is invalid without a description" do
    drink = build(:food, description: nil)
    drink.valid?
    expect(drink.errors[:description]).to include("can't be blank")
  end

  it "is valid price" do
    drink = build(:drink, price: 6000.00)
    expect(drink).to be_valid
  end

  it "is invalid with non-numerical values" do
    drink = build(:drink, price: '6ribu')
    drink.valid?
    expect(drink.errors[:price]).to include("is not a number")
  end

  it "is invalid if price less than 0.01" do
    drink = build(:drink, price: 0.0)
    drink.valid?
    expect(drink.errors[:price]).to include("must be greater than or equal to 0.01")
  end

  it "is valid image url" do
    drink = build(:drink, image_url: "image.png")
    expect(drink).to be_valid
  end

  it "is invalid without .jpg, .gif, or .png image" do
    drink = build(:drink, image_url: "image.lol")
    drink.valid?
    expect(drink.errors[:image_url]).to include("must be a URL for GIF, JPG, or PNG image.")
  end

  it "returns a sorted array of results that match" do
    drink1 = create(:drink, name: 'Lemon Tea')
    drink2 = create(:drink, name: 'Melon Juice')
    drink3 = create(:drink, name: 'Mango Juice')
    expect(Drink.by_letter('M')).to eq([drink3, drink2])
  end

  it "can't be destroyed while it has line_item(s)" do
    cart = create(:cart)
    drink = create(:drink)
    line_item = create(:line_item, cart: cart, drink: drink)
    drink.line_items << line_item

    expect { drink.destroy }.not_to change(Drink, :count)
  end
end
