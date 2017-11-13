require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is valid with a username" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a username" do
    user = build(:user, username: nil)
    user.valid?
    expect(user.errors[:username]).to include("can't be blank")
  end

  it "is invalid with duplicate username" do
    user1 = create(:user, username: "arish")
    user2 = build(:user, username: "arish")
    user2.valid?
    expect(user2.errors[:username]).to include("has already been taken")
  end

  context "on a new user" do
    it "is invalid without a password" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "is invalid with less than 8 characters long" do
      user = build(:user, password: "short", password_confirmation: "short")
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it "is invalid with a confirmation mismatch" do
      user = build(:user, password: "shortpassword", password_confirmation: "longpassword")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context "on an existing user" do
    before :each do
      @user = create(:user)
    end

    it "is invalid with no changes" do
      expect(@user.valid?).to eq(true)
    end

    it "is invalid with an empty password" do
      @user.password_digest = ""
      @user.valid?
      expect(@user.errors[:password]).to include("can't be blank")
    end

    it "is invalid a confirmation mismatch" do
      @user.password = "shortpassword"
      @user.password_confirmation = "longpassword"
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe "TopUp" do
    before :each do
      @user = create(:user, credit: 200000.00)
    end

    context "with valid attributes" do
      it "is valid with an amount" do
        expect(build(:user)).to be_valid
      end

      it "is valid with amount greater than 0"

      it "will add the credit after topup"
    end

    context "with invalid attributes" do
      it "is invalid with empty amount" do

      end

      it "is invalid with non-numeric amount"
    end
  end
end
