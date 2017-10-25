require 'rails_helper'

describe Food do
  it "is valid with a name and description" do
    food = Food.new(
      name: "Nasi uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0
    )
    expect(food).to be_valid
  end

  it "is invalid without a name" do
    food = Food.new(
      name: nil,
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0
    )
    # jika method valid? => false maka ruby akan otomatis menambahkan method errors ke food yang pesannya dapat kita ambil
    # untuk membandingkan apa yang kita expect dengan hasil test
    # pesan-pesan error tersebut dapat dilihat di github rails-i18n (https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/en.yml)
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it "is invalid without description" do
    food = Food.new(
      name: "Nasi Goreng",
      description: nil,
      price: 13000.0
    )
    food.valid?
    expect(food.errors[:description]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    # Methode create memasukan data ke dalam database di dalam environment test
    food_satu = Food.create(
      name: "Nasi uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0
    )
    # Method new untuk instantiasi class Food. Karena data name yang di-instance sudah masuk ke dalam database maka akan ruby akan menambahkan method errors
    # pada objek food_dua. Dan kita dapat mengambil dan membandingkan pesan error-nya.
    # Sehingga test ini menjadi passed. 
    food_dua = Food.new(
      name: "Nasi uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0
    )
    food_dua.valid?
    expect(food_dua.errors[:name]).to include("has already been taken")
  end
end
