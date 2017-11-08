require 'rails_helper'

RSpec.describe Tag, type: :model do
  it "has a valid factory" do
    expect(build(:tag)).to be_valid
  end
  it "is valid with a name" do
    tag = build(:tag)
    expect(tag).to be_valid
  end
  it "is invalid wihout a name" do
    tag = build(:tag, name: nil)
    tag.valid?
    expect(tag.errors[:name]).to include("can't be blank")
  end
  it "is invalid with a duplicate name" do
    tag1 = create(:tag, name: "sama")
    tag2 = build(:tag, name: "sama")
    tag2.valid?
    expect(tag2.errors[:name]).to include("has already been taken")
  end
end
