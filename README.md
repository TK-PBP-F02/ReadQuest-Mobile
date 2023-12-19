# ReadQuest
![Alt text](ReadQuestLogo.png)

## Link Aplikasi
[ReadQuest](https://install.appcenter.ms/users/hafizmuh18/apps/readquest/distribution_groups/public)  

[![Build status](https://build.appcenter.ms/v0.1/apps/6ec97745-22cb-4782-a495-aafdf78e7a2c/branches/main/badge)](https://appcenter.ms)

### Angota Kelompok
------
`Abbilhaidar Farras Zulfikar`  
`Johanes Wisanggeni`  
`Elena Zahra Kurniawan`  
`Muhammad Hafiz`  
`Rifqi Pratama Artyanto`  

### Aplikasi ReadQuest
------
ReadQuest adalah aplikasi permainan dengan tema dan basis literasi buku. Pengguna dapat melihat list overview dari buku-buku yang ada seperti penulis, harga, genre serta deskripsi singkat dari bukunya. Pengguna juga dapat memasukan buku-buku tersebut ke dalam wishlist bacaan nya, dan jika pengguna sudah membaca buku tersebut maka pengguna akan mendapatkan poin (BookCoin <BC>), dimana semakin banyak BC yang dimiliki pengguna tersebut maka semakin tinggi juga posisi atau ranking pengguna di dalam leaderboard. Selain itu pengguna juga dapat memanfaatkan BC kepada hal-hal lain seperti memenuhi achivement. Achivement adalah sebuah pencapaian atau penghargaan yang dapat dicapai oleh pengguna dengan menyelesaikan misi-misi tertentu seperti membaca 10 buku dalam seminggu atau berhasil mengoleksi 100 BC, pengguna akan diberikan trophy dari achivement tersbut serta dapat mendapatkan poin BC.  
  
Selain itu pengguna juga dapat membuat bukunya tersendiri dimana bukunya dapat dipublish di dalam aplikasi ReadQuest dan pengguna lain dapat membaca buku-buku dari pengguna lain. Serta sesama pengguna dapat berdiskusi di dalam suatu forum diskusi yang disediakan di setiap buku, atau forum diskusi secara general dimana sesama pengguna dapat berinteraksi dan mendiskusikan sesuatu.  
  
Dengan menggabungkan konsep permainan yang asik melalui misi, ranking dan achivement dan konsep literasi buku yang penting di dalam kehidupan, ReadQuest bertujuan menjadikan literasi buku yang terasa membosankan menjadi asik dengan memberika fitur-fitur seperti permainan ke dalam literasi. Serta menyediakan tempat dimana sesama pencinta buku dapat berdiskusi dan memberikan tanggapan-tanggapan mereka.

Manfaat atau Tujuan ReadQuest :  
- Memberikan tempat dimana pengguna dapat mencari buku yang diingikanya serta measukanya ke dalam wishlistnya.
- ReadQuest menyediakan tempat diskusi antara sesama pencinta buku untuk asling berdiskusi dan memberikan tanggapan mereka.
- ReadQuest juga memberikan tempat bagi para pengguna yang tertarik untuk menulis buku, untuk menciptakan dan mengpublish bukunya sendiri ke dalam aplikasi.
- Untuk membuat literasi menjadi tidak terasa membosankan ReadQuest menggabungkan konsep bermain seperti ranking dan leaderboard.
- Pengguna dapat memperoleh point BC dan achivement untuk membuat literasi menjadi lebih asik.

### Modul Aplikasi ReadQuest
------
1. *Round Table* `Abbilhaidar Farras Zulfikar`  : Forum diskusi dimana pengguna dapat berinteraksi satu sama lain, membahas segala macam topik seperti memberi tanggapan atau penilaian pada suatu buku.
   - Login : Dapat langsung menambahkan forum baru dan membalas-balas forum dari pengguna lain.
   - Unlogin : Unlogin user dapat melihat forum-forum diskusi dan juga dapat membalas forum pengguna lain, namun harus mengisi username buat tampilannya.
2. *Inventory* `Elena Zahra Kurniawan`  : Isi dari buku-buku wishlist buku yang ingin dibaca, buku yang sedang dibaca ataupun buku yang sudah pernah dibaca oleh pengguna.
   - Login : Berisi data-data buku yang sudah dibaca/ ingin dibaca/ ingin dibelli.
   - Unlogin : Berisi halaman inventory kosong dan memberikan tombol pilihan bagi pengguna untuk membuat akun atau login.
3. *Make Journey Jurnal* `Johanes Wisanggeni`  : Pengguna membuat bukunya sendiri yang kemudian dapat dipublish dan dibaca oleh pengguna-pengguna lain.
   - Login : Pengguna dapat membuat buku dan memilih untuk membuat buku yang dibuatnya public atau private.
   - Unlogin : Pengguna yang belum login juga dapat membuat bukunya sendiri namun harus mengisi data dirinya terlebih dahulu untuk melengkapi.
4. *Quest* `Muhammad Hafiz`  : Achivement-achivement atau misi-misi yang dapat dilaksanakan oleh pengguna untuk memperoleh point.
   - Login : User dapat melihat dan menyelesaikan misi.
   - Unlogin : User yang tidak login hanya dapat melihat deskripsi dari user, tetapi tidak bisa menyelesaikan.
   - Admin : Membuat misi untuk user-user lain.
5. *Leaderboard Ranking* `Rifqi Pratama Artyanto`  : Ranking leaderboard untuk tiap user yang mendaftarkan dirinya ke dalam leaderboard untuk bisa di ranking di dalam sistem ranking leaderboard.
   - Login : User dapat mellihat dan memasukan data dirinya untuk masuk ke dalam daftar ranking leaderboard.
   - Unlogin : User yang tidak login, hanya dapat melihat rangking leaderboard tetapi tidak dapat mendaftarkan diri ke dalam leaderboard.

### User Role
------
1. *Unlogin* : Pengguna yang tidak login atau tidak memiliki akun, maka pengguna tetap dapat mengakses aplikasi seperti mengakses katalog buku tetapi dengan fitur yang jauh lebih sedikit.  
2. *Login* : Pengguna yang memiliki akun dan sudah login, maka pengguna dapat memiliki fitur tambahan seperti memiliki wishlist, membuat buku, memulai forum diskusi dan memperoleh point.  
3. *Admin* : Admin yang memiliki privilage otoritas yang lebih banyak dan lebih tinggi dibanding pengguna-pengguna lain, seperti dapat memeriksa info user, memblokir user, membuat quest dan sebagainya.  

### Integrasi Web
------
1. Menerapkan fungsi yang dapat mengembalikan response json di views project django, dan melakukan raouting url nya, sehingga web django dapat memberikan json dari model-model dari django ke flutter, sehingga model tersebut dapat digunakan dan diterapkan di project flutter.
2. Menerapkan model pada project flutter, untuk dapat mengelola data json yang diambil dari django menjadi object model pada flutter, sehingga data tersebut dapat menjadi model/object yang dapat dimanfaatkan pada flutter.
3. Pada flutter menambahkan fetch data, sehingga dapat melakukan request POST, GET, serta DELETE untuk mengambil data pada database project django.
4. Melakukan pengelolahan data yang diterima dari json pada web, sehingga membentuk data tersebut menjadi object model yang sesuai pada flutter.
5. Object model yang sudah disesuaikan kemudian ditampilkan di dalaam mobile aplication.

### Berita Acara
------
[Berita Acara](https://docs.google.com/spreadsheets/d/1V1QlxNnpwR8CNAxFX-MXNgsBw5YUmY8ZR5nN1DG4D3M/edit?hl=id#gid=0)
