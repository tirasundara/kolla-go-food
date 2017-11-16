require 'rails_helper'

RSpec.describe Role, type: :model do
  it "has a valid factory" do
    expect(build(:role)).to be_valid
  end
  it "is valid with a name" do
    expect(build(:role)).to be_valid
  end
  it "is invalid without a name" do
    role = build(:invalid_role)
    role.valid?
    expect(role.errors[:name]).to include("can't be blank")
  end
  it "is invalid with duplicate name" do
    role1 = create(:role, name: 'admin')
    role2 = build(:role, name: 'admin')
    role2.valid?
    expect(role2.errors[:name]).to include("has already been taken")
  end
end
