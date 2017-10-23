# README

Aplikasi ini adalah aplikasi yang dibuat pada saat program Go-Scholar Tech Ruby on Rails. Secara sederhananya aplikasi ini memungkinkan user untuk memesan makanan secara online. Tapi saat ini apliasi masih berada pada tahap awal (pengembangan), sehingga belum berfungsi secara maksimal.

* Aplikasi ini menggunakan Ruby versi 2.4.2 dengan framework Ruby on Rails
  Untuk menginstall rails di mesin Linux anda, maka lakukan:
  - Cek apakah rails sudah terinstall dengan perintah: rails -v
  - Jika belum, maka ketikkan perintah: gem install rails
  Langkah-langkah diatas dapat dilakukan dengan asumsi bahwa pada PC/Laptop anda sudah terpasang Ruby. Jika belum, anda dapat mencari cara menginstall ruby di Google. Saya sarankan anda menginstall ruby menggunakan RVM.
* Buat project baru pada rails
  Jika rails sudah berhasil terinstall maka langkah selanjutnya adalah membuat project baru. Untuk membuat project baru, ketikkan perintah: rails new go-food
  Maka rails akan secara otomatis membangun struktur direktori untuk project baru bernama go-food tersebut. Anda dapat masuk ke directory go-food dengan perintah: cd go-food
* Jalankan Rails Server
  - Untuk memastikan bahwa project yang anda buat berhasil diakses melalui web maka ketikkan perintah: rails server
  - Jika terdapat error 'Could not find a JavaScript runtime', maka lakukan:
    + Di dalam direktory go-food, buka file Gemfile menggunakan teks editor yang anda gunakan
    + Uncomment (hapus tanda pagar) yang ada pada baris 20, lalu Save
    + Kembali ke terminal, lalu ketik perintah: bundle
    + Lalu ketik perintah: rails server
    + Seharusnya rails server sudah berhasil berjalan. Tapi jika masih error coba diskusikan disini
  - Setelah rails server berhasil berjalan. Langkah selanjutnya adalah mengecek halaman web project go-food menggunakan web browser. Jalankan web browser favorit anda, lalu ketikan ini pada url: http://localhost:3000/
  - Jika tampilan pada browser adalah gambar dan terdapat tulisan 'Yeay, you are on rails!' maka selamat anda telah berhasil menjalankan project Ruby on Rails pertama anda.
* Membuat controller baru
  - Perintah untuk membuat controller baru: rails generate [controller_name] [action]
  - Dalam project ini: rails generate Home hello
  - Cek di http://localhost:3000/home/hello
* Menyelipkan kode Ruby diantara tag-tag HTML
  Tag yang digunakan untuk mengeksekusi kode Ruby diantara tag-tag HTML adalah:
  + <%= Time.now %> kode ini akan menampilkan timestamps saat ini di browser. Perhatikan bawah terdapat tanda '=' (sama dengan) pada tag pembuka
  + <% Time.now %> evaluasi dari kode ini sama untuk mendapatkan timestamps saat ini, bedanya kode ini tidak akan menampilkan hasil evaluasi kode ke browser (perhatikan tidak ada tanda '=')
* Menambah Action Baru
  Untuk menambah action baru pada sebuah controller, terdapat 3 file yang harus diubah. Misalnya kita hendak menambah action goodbye pada controller Home. Maka 3 file yang harus diubah adalah:
  + file config/routes.rb
    Tambahkan perintah: get 'home/goodbye'
  + file controller/home_controller.rb
    Tulis kode:
    def goodbye
      @tomorrow = Date.today + 1.day
    end
  + buat file views/goodbye.html.erb
    Tulis kode:
    <h1>Good bye</h1>
      <p>See you on <%= @tomorrow.strftime("%A") %></p>
* Membuat Model Baru
  - Di linux terminal ketik: rails generate model user
  - Oh iya, jangan lupa untuk selalu commit github anda setelah melakukan perubahan pada project.
  - Lanjut, rails menggunakan sistem migrate untuk melakukan tugas-tugas yang berkaitan dengan database. Lebih lengkapnya anda dapat browsing mengenai bagaimana konsep migrate bekerja. Tetapi intinya dengan konsep migrate ini, programmer tidak perlu mengubah struktur tabel/database secara langsung menggunakan perintah-perintah SQL. Hal ini bertujuan untuk menjaga konsistensi struktur tabel/database.
  - Programmer membuat struktur tabel/database melalui perintah yang dituliskan dalam file .rb yang ada pada direktori db/migrate/ misalnya: db/migrate/20171023073437_create_users.rb. Edit file tersebut lalu tambahkan perintah ini di dalam blok create_table:
    t.string :username, null: false
    t.string :fullname
  - Kembali ke terminal, ketik: rails db:create (Ini untuk pertama kali saja, karena kita belum memiliki database)
  - Masih di terminal, ketik: rails db:migrate
  - Selamat, anda telah berhasil membuat database dan tabel pertama anda
* Menggunakan Ruby Console
  Ruby console merupakan tool yang berguna untuk proses mengeksekusi perintah-perintah ruby. Biasanya ini digunakan untuk proses debugging, atau pada saat tahap development untuk memanipulasi data pada tabel, atau untuk mencoba menjalnkan suatu perintah atau method ruby
  - Untuk membuka ruby console, ketik di terminal: rails c
  - Ketik: User (akan menampilkan bahwa model user belum memiliki koneksi ke database)
  - Ketik: User.connection
  - Ketik: User (akan tampil struktur tabel yang telah kita definisikan sebelumnya. Perhatikan bahawa rails secara otomatis membuat field-field baru seperti id yang bertindak sebagai primary key dan kolom timestamps)
  - Untuk menambah data baru ke tabel: User.create( username: 'testuser', fullname: 'Test User')
  - Ketik: User.find(1) => Untuk menyeleksi data yang ada pada tabel dengan kriteria id = 1
  - Ketik: User.where(username: 'testuser') => menyeleksi data pada tabel dengan kriteria username = 'testuser'
  - Masih banyak hal yang bisa dilakukan pada console tersebut. Anda bisa membacanya di dokumentasi ruby on rails: http://edgeguides.rubyonrails.org/active_record_querying.html
* Menampilkan data-data user ke web browser
  - Buka file controllers/home_controller.rb
  - Di dalam method hello, tambahkan: @users = User.all
  - Buka file views/hello.html.erb
  - Tambahkan:
    Registered users:
    <ul>
    <% @users.each do |user| %>
      <li> <%= user.fullname %> - <%= user.username %></li>
    <% end %>
    </ul>
  - Buka http://localhost:3000/home/hello
