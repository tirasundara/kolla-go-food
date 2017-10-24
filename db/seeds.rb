# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Memastikan bahwa class Food bersih
Food.delete_all

Food.create!(
  name: "Bakso Malang",
  description:
  %{
    <p>
    <em>Bakso ter-apa ya</em>
    Bakso eta gg
    </p>
  },
  image_url: "bakso_malang.jpg",
  price: 15000.00
)

Food.create!(
  name: "Mie Ayam",
  description:
  %{
    <p>
    Mie + Ayam = Mie-nya dimakan ayam
    </p>
  },
  image_url: "mie_ayam.jpg",
  price: 20000.00
)

Food.create!(
  name: "Soto Betawi",
  description:
  %{
    <p>
    Soto + Betawi = Soto Betawi
    </p>
  },
  image_url: "soto_betawi.jpg",
  price: 16000.00
)
