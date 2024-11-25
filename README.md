# LokaKarya - Aplikasi Informasi Kerajinan Tangan di Kota Jepara

Tautan untuk menuju Lokakarya -> [http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/](http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/)

## Nama-nama Anggota Kelompok
- Muhammad Yahya Ayyas - 2306212083
- Azzahra Salsabila - 2306219934
- Muhammad Daffa Abyaz Tjiptadi - 2306210443
- Harman Hakim - 2306240080
- Orlando Devito - 2306165950
- Belva Ghani Abhinaya - 2306203526

## Deskripsi Aplikasi
Aplikasi "LokaKarya" bertujuan untuk mempermudah pengguna menemukan kerajinan tangan yang dijual di berbagai toko di kota Jepara. Aplikasi ini memberikan informasi detail mengenai produk kerajinan tangan, seperti ukiran, anyaman, dan patung, serta lokasi toko yang menjualnya. Pengguna dapat mencari produk spesifik dan menemukan toko terdekat yang menjual produk tersebut.

### Kebermanfaatan
- *Untuk Calon Pembeli*: Memudahkan pencarian produk kerajinan tangan spesifik di berbagai toko di Jepara tanpa harus mengunjungi toko satu per satu.
- *Untuk Pemilik Toko*: Menyediakan platform promosi di mana pemilik toko dapat mendaftarkan produk mereka dan menjangkau lebih banyak pembeli.

## Daftar Modul yang Akan Diimplementasikan
1. *Landing Page*:
   - Menampilkan kategori utama kerajinan tangan yang tersedia.
   
2. *Login/Register Modul*:
   - Opsi login bagi pembeli dan pemilik toko.
   - Pemilik toko bisa mengelola produk mereka melalui dashboard.

3. *Produk Page* (Orlando Devito):
   - Menampilkan daftar produk kerajinan tangan.
   - Setiap produk akan menunjukkan toko mana yang menjualnya beserta informasi harga dan deskripsi produk.

4. *Toko Page* (Muhammad Yahya Ayyas):
   - Informasi lengkap mengenai toko: lokasi, jam buka, dan produk yang dijual.

5. *Admin Dashboard* (untuk pemilik toko) (Daffa Abyaz Tjiptadi):
   - Fitur untuk menambahkan, memperbarui, atau menghapus produk yang dijual.

6. *User Profile* (Belva Ghani Abhinaya):
   - Informasi lengkap mengenai profil user (Pembeli, pemilik toko, admin)
     
7. *Forum and Review Page* (Azzahra Salsabila):
   - Fitur untuk menambahkan forum dan halaman ulasan
   - Role Pembeli dapat membuat ulasan dan menambahkan forum untuk toko.

8. *Customer's Favorite Things Page* (Harman Hakim):
   - Fitur untuk menambahkan barang favorit role Pembeli

## Sumber Initial Dataset
Kategori produk yang akan ditampilkan di aplikasi:
- *Ukiran Kayu*
- *Anyaman Bambu*
- *Patung*
- *Cendera mata*
- *Aksesoris*
- *Fashion*
- *Keramik*
- *Batik Jepara*<br/>

List initial dataset dapat diakses pada tautan berikut ->  [ristek.link/LokaKaryaDataset](https://docs.google.com/spreadsheets/d/1iwVvKY70utZZBPC0xP1HDhbXZJZnOaFHTg-w9wlMwY0/edit?gid=0#gid=0)

## Role Pengguna
1. *Pembeli*:
   - Dapat mendaftar atau menggunakan situs sebagai tamu.
   - Mencari produk berdasarkan kategori atau kata kunci.
   - Mengakses informasi detail tentang produk dan toko.
   - Menyimpan toko atau produk sebagai favorit (jika terdaftar).

2. *Pemilik Toko*:
   - Mendaftar dan mengelola toko mereka.
   - Menambahkan dan memperbarui produk yang dijual.
   - Melihat statistik performa produk atau toko mereka di platform.

3. *Admin*:
   - Mengelola data produk dan toko yang terdaftar di platform.
   - Memantau aktivitas pengguna dan memoderasi konten.

## Langkah-Langkah Integrasi dengan Web Service

### 1. **Identifikasi Kebutuhan dan Perancangan Aplikasi**
   Kami memulai dengan menentukan fitur utama yang harus disediakan oleh web service, seperti mengambil data produk dan validasi pengguna.  
   Selanjutnya, kami mengidentifikasi format data yang digunakan, yakni JSON, dan mencatat endpoint yang disediakan oleh web service.

### 2. **Konfigurasi dan Koneksi ke Web Service**
   Data yang dikirim ke aplikasi Flutter adalah dalam format JSON. Ketika Flutter mengirim permintaan data ke server, Django akan mengirimkan respons dalam format JSON.  
   Untuk koneksi, aplikasi Flutter menggunakan paket `http` untuk melakukan request ke endpoint yang sesuai di web service, dan menerima respons untuk diproses lebih lanjut.

### 3. **Pengujian Proses Integrasi**
   Sebelum menghubungkan web service ke aplikasi, kami menggunakan alat seperti Postman untuk menguji setiap endpoint dan memahami format responsnya.  
   Pengujian dilakukan pada berbagai skenario, baik keberhasilan maupun kegagalan, untuk memastikan sistem siap digunakan. Kami memeriksa data yang dikirim, autentikasi, serta memastikan respons API sesuai dengan yang diharapkan.

### 4. **Pengembangan User Interface**
   Setelah integrasi teknis selesai, kami membuat antarmuka pengguna (UI/UX) untuk mengolah dan menampilkan data yang diperoleh dari web service secara intuitif dan interaktif.  
   UI dirancang dengan memperhatikan pengalaman pengguna, memastikan tampilan produk, toko, dan informasi lainnya mudah diakses dan digunakan.

### 5. **Deployment dan Pemantauan**
   Kami memastikan koneksi ke web service tetap stabil saat aplikasi dijalankan.  
   Performa web service, termasuk waktu respons dan error log, dipantau secara berkala untuk menjaga kelancaran operasional aplikasi. Kami juga menggunakan alat pemantauan untuk mendeteksi gangguan dan melakukan perbaikan jika diperlukan.
