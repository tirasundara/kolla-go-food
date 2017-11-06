require 'rails_helper'

RSpec.describe Category, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "has a valid factory" do
    expect(build(:category)).to be_valid
  end
  it "invalid without a name" do
    category = build(:category, name: nil)
    category.valid?
    expect(category.errors[:name]).to include("can't be blank")
  end

  it "is valid with a name" do
    category = build(:category)
    expect(category).to be_valid
  end

  it "is invalid with duplicate name" do
    categ1 = create(:category, name: 'traditional')
    categ2 = build(:category, name: 'traditional')
    categ2.valid?
    expect(categ2.errors[:name]).to include('has already been taken')
  end

  it "can't be destroyed while it has food(s)" do
    category = create(:category)
    food = create(:food, category: category)

    expect { category.destroy }.not_to change(Category, :count)
  end
end
