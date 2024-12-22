# LokaKarya - Aplikasi Informasi Kerajinan Tangan di Kota Jepara

Tautan untuk menuju Lokakarya -> [http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/](http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/)<br>
Tautan untuk instalasi apk LokaKarya -> [App Lokakarya](https://install.appcenter.ms/orgs/PBP-A-01/apps/LokaKarya/releases/1)

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

## Panduan Integrasi dengan Web Service

### 1. **Desain dan Kebutuhan Aplikasi**
   Fitur utama yang disediakan oleh web service antara lain adalah pengambilan data produk, informasi toko, serta validasi pengguna. Kami memilih format data JSON untuk komunikasi antar aplikasi dan server. Endpoint yang disediakan diidentifikasi dan dipetakan dengan kebutuhan aplikasi.

### 2. **Menghubungkan Aplikasi dengan Web Service**
   Aplikasi Flutter akan mengirim permintaan HTTP kepada server Django, yang akan memberikan respons dalam format JSON. Kami menggunakan paket `http` di Flutter untuk melakukan request dan mendapatkan respons data.

### 3. **Pengujian Web Service**
   Sebelum mengintegrasikan dengan aplikasi, kami menggunakan Postman untuk menguji dan memverifikasi endpoint serta format data yang diterima dari server. Pengujian dilakukan pada berbagai skenario, termasuk kasus error dan validasi data.

### 4. **Pengembangan Antarmuka Pengguna**
   Setelah integrasi selesai, UI dikembangkan dengan fokus pada pengalaman pengguna. Data dari web service ditampilkan secara dinamis dengan navigasi yang memudahkan pengguna untuk mengakses produk, toko, dan informasi lainnya.

### 5. **Deployment dan Pemantauan**
   Koneksi ke web service terus dipantau untuk memastikan aplikasi berjalan dengan lancar. Kami memantau kinerja API dan waktu respons untuk memastikan sistem tidak terganggu.

[![Build status](https://build.appcenter.ms/v0.1/apps/7c327f13-1aee-414c-a408-b78e80000e0b/branches/master/badge)](https://appcenter.ms)
