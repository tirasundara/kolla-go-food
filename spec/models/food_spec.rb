require 'rails_helper'

describe Food do
  # ============ RSpec Without using FactoryGirl ============================================================
  describe "validating presence of name and description" do
    before :each do
      @food = Food.new(
        name: nil,
        description: nil,
        price: 10000.0
      )
    end
    context "without a name" do
      it "is invalid without a name" do
        @food.valid?
        # jika method .valid? => false maka ruby akan otomatis menambahkan method errors ke food yang pesannya dapat kita ambil
        # untuk membandingkan apa yang kita expect dengan hasil test
        # pesan-pesan error tersebut dapat dilihat di github rails-i18n (https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/en.yml)
        expect(@food.errors[:name]).to include("can't be blank")
      end
    end
    context "without a description" do
      it "is invalid without description" do
        @food.valid?
        expect(@food.errors[:description]).to include("can't be blank")
      end
    end
  end

  it "is valid with a name and description" do
    restaurant = create(:restaurant)
    food = Food.new(
      name: "Nasi uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0,
      restaurant: restaurant
    )
    expect(food).to be_valid
  end

  it "is invalid with a duplicate name" do
    restaurant = create(:restaurant)
    # Methode create memasukan data ke dalam database di dalam environment test
    food_satu = Food.create(
      name: "Nasi uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0,
      restaurant: restaurant
    )
    # Method new untuk instantiasi class Food. Karena data name yang di-instance sudah masuk ke dalam database maka akan ruby akan menambahkan method errors
    # pada objek food_dua. Dan kita dapat mengambil dan membandingkan pesan error-nya.
    # Sehingga test ini menjadi passed.
    food_dua = Food.new(
      name: "Nasi uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0,
      restaurant: restaurant
    )
    food_dua.valid?
    expect(food_dua.errors[:name]).to include("has already been taken")
  end


  # Untuk menjalankan prinsip DRY. Kita dapat menuliskan RSpec menggunakan before, context,
  describe "filter name by letter" do
    before :each do
      @food_satu = Food.create(
        name: "Nasi Uduk",
        description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
        price: 10000.0
      )
      @food_dua = Food.create(
        name: "Kerak Telor",
        description: "Betawi traditional spicy omelette made from glutinous rice cooked with egg.",
        price: 8000.0
      )
      @food_tiga = Food.create(
        name: "Nasi Kuning",
        description: "Based on dongfruit, this menu promises a unique and delicious taste with...",
        price: 8000.0
      )
    end

    # context "with matching letter" do
    #   it "returns a sorted array of results that match" do
    #     expect(Food.by_letter("N")).to eq([@food_tiga, @food_satu])
    #   end
    # end
    # context "with non-matching letter" do
    #   it "omits results that do not match" do
    #     expect(Food.by_letter("N")).not_to include(@food_dua)
    #   end
    # end
  end

  it "is invalid with non-numerical values" do
    food = Food.new(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 'abcd'
    )
    food.valid?
    expect(food.errors[:price]).to include("is not a number")
  end


  describe "price and image field test" do
    before :each do
      @min_allowed_price = 0.01
      @food = Food.new(
        name: "Nasi Uduk",
        description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
        price: 0.0,
        image_url: "eta_gg"
      )
    end

    context "price must be greater_than_or_equal_to #{@min_allowed_price}" do
      it "is invalid if price less than #{@min_allowed_price}" do
        @food.valid?
        expect(@food.errors[:price]).to include("must be greater than or equal to #{@min_allowed_price}")
      end
    end
    context "type of image file" do
      it "is invalid without .jpg, .gif, or .png image" do
        @food.valid?
        expect(@food.errors[:image_url]).to include("must be a URL for GIF, JPG, or PNG image.")
      end
    end
  end
  # ==================== End of RSpec Without FactoryGirl ====================================================

  # ==================== RSpec with FactoryGirl ===============================================================
  it "has a valid factory" do
    expect(build(:food)).to be_valid
  end

  it "invalid without a name" do
    food = build(:food, name: nil)
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a description" do
    food = build(:food, description: nil)
    food.valid?
    expect(food.errors[:description]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    food_satu = create(:food, name: "Nasi Merah")
    food_dua = build(:food, name: "Nasi Merah")
    food_dua.valid?
    expect(food_dua.errors[:name]).to include("has already been taken")
  end

  it "is valid price" do
    food = build(:food)
    expect(food).to be_valid
  end

  it "is invalid with non-numerical values" do
    food = build(:food, price: '123hallo')
    food.valid?
    expect(food.errors[:price]).to include("is not a number")
  end

  it "is invalid if price less than 0.01" do
    food = build(:food, price: 0.0)
    food.valid?
    expect(food.errors[:price]).to include("must be greater than or equal to 0.01")
  end

  it "is valid image url" do
    food = build(:food)
    expect(food).to be_valid
  end

  it "is invalid without .jpg, .gif, or .png image" do
    food = build(:food, image_url: 'eta.gg')
    food.valid?
    expect(food.errors[:image_url]).to include("must be a URL for GIF, JPG, or PNG image.")
  end

  it "returns a sorted array of results that match" do
    food2 = create(:food, name: 'Nasi Kuning')
    food3 = create(:food, name: 'Nasi Goreng')
    food = create(:food, name: 'Kerak Telor')
    expect(Food.by_letter("N")).to eq([food3, food2])
  end

  it "can't be destroyed while it has line_item(s)" do
    cart = create(:cart)
    food = create(:food)

    line_item = create(:line_item, cart: cart, food: food)
    food.line_items << line_item

    expect { food.destroy }.not_to change(Food, :count)
  end


  # =========== End of RSpec with FactoryGirl =================================================================

end
