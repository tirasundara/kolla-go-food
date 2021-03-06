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


Buyer.delete_all
Buyer.create!(
  name: "Tira Sundara",
  email: "sundaralinus@gmail.com",
  phone: "085793060639",
  address: "Jl. Kemana saja"
)

Buyer.create!(
  name: "Anugrah Putra",
  email: "anugrah.putra@gmail.com",
  phone: "085793060777",
  address: "Jl. In aja dulu"
)

Buyer.create!(
  name: "Rizal Rahman",
  email: "om.risal@cilsy.id",
  phone: "089893060666",
  address: "Jl. Cilsy Fiolution"
)

Buyer.create!(
  name: "Kahpiw",
  email: "the.noob@gmail.com",
  phone: "085793060444",
  address: "Jl. Padjajaran No. 666"
)

Buyer.create!(
  name: "M. Naufal A",
  email: "opay@yahoo.co.id",
  phone: "089893060333",
  address: "Jl. Batu Jajar Squad"
)

Role.delete_all
Role.create!(
  name: 'administrator'
)
Role.create!(
  name: 'customer'
)
