require 'rails_helper'

RSpec.describe Restaurant do
  it "has a valid factory" do
    expect(build(:restaurant)).to be_valid
  end
  it "is valid with a name, and an address" do
    restaurant = build(:restaurant, name: "RM Raja Rasa", address: "Jl. Roso No. 33")
    expect(restaurant).to be_valid
  end
  it "is invalid without a name" do
    restaurant = build(:restaurant, name: nil)
    restaurant.valid?
    expect(restaurant.errors[:name]).to include("can't be blank")
  end
  it "is invalid with duplicate name" do
    restaurant1 = create(:restaurant, name: "RM sama")
    restaurant2 = build(:restaurant, name: "RM sama")
    restaurant2.valid?
    expect(restaurant2.errors[:name]).to include("has already been taken")
  end
  it "is invalid without an address" do
    restaurant = build(:restaurant, address: nil)
    restaurant.valid?
    expect(restaurant.errors[:address]).to include("can't be blank")
  end
  it "is invalid with duplicate address" do
    restaurant1 = create(:restaurant, address: "Jl. Sama")
    restaurant2 = build(:restaurant, address: "Jl. Sama")
    restaurant2.valid?
    expect(restaurant2.errors[:address]).to include("has already been taken")
  end
end
