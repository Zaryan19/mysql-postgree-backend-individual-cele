-- 1. Tabel users admin (Relasi 1:1 ke admin_profile)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    role VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabel admin profile (Relasi 1:1 dari users)
CREATE TABLE admin_profile (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    nama_admin VARCHAR (100) NOT NULL,
    no_hp VARCHAR (20) NOT NULL,
    foto VARCHAR (255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Tabel Pemerintah desa
CREATE TABLE pemerintah_desa (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    jabatan VARCHAR(50) NOT NULL,
    foto VARCHAR (255),
    no_hp VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabel Profile desa
CREATE TABLE profile_desa (
    id SERIAL PRIMARY KEY,
    nama_desa VARCHAR(100) NOT NULL,
    sejarah TEXT NOT NULL,
    visi_misi TEXT NOT NULL,
    geografis TEXT NOT NULL,
    alamat_kantor TEXT NOT NULL,
    jam_operasional VARCHAR(100) NOT NULL,
    peta_iframe TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabel Berita & Informasi (Relasi N:1 ke users)
CREATE TABLE berita (
    id SERIAL PRIMARY KEY,
    author_id INTEGER NOT NULL,
    judul VARCHAR(255) NOT NULL,
    kategori VARCHAR(50) NOT NULL, -- Contoh: 'Musdes', 'Rapat RT/RW', 'Pengumuman'
    isi_berita TEXT NOT NULL,
    gambar_sampul VARCHAR(255),
    tgl_publikasi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Tabel UMKM
CREATE TABLE umkm (
    id SERIAL PRIMARY KEY,
    nama_usaha VARCHAR(150) NOT NULL,
    pemilik VARCHAR(100) NOT NULL,
    no_wa VARCHAR(20) NOT NULL,
    alamat TEXT NOT NULL,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Tabel Produk UMKM (Relasi 1:N dari umkm)
CREATE TABLE produk_umkm (
    id SERIAL PRIMARY KEY,
    umkm_id INTEGER NOT NULL,
    nama_produk VARCHAR(150) NOT NULL,
    harga NUMERIC(12, 2) NOT NULL,
    foto_url VARCHAR(255),
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_umkm FOREIGN KEY (umkm_id) REFERENCES umkm(id) ON DELETE CASCADE
);

-- 8. Tabel Event Desa (Agenda tahunan, festival, bazar)
CREATE TABLE event_desa (
    id SERIAL PRIMARY KEY,
    nama_event VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    tgl_mulai TIMESTAMP NOT NULL,
    tgl_selesai TIMESTAMP,
    lokasi VARCHAR(255) NOT NULL,
    foto_banner VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Tabel Pivot Event UMKM (Relasi M:N antara event_desa dan umkm)
CREATE TABLE event_umkm (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    umkm_id INTEGER NOT NULL,
    nomor_stand VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES event_desa(id) ON DELETE CASCADE,
    CONSTRAINT fk_umkm_event FOREIGN KEY (umkm_id) REFERENCES umkm(id) ON DELETE CASCADE,
    CONSTRAINT uq_event_umkm UNIQUE (event_id, umkm_id) -- Mencegah UMKM didaftarkan ganda di 1 event yang sama
);



-- insert into
INSERT INTO events (nama_event, deskripsi, tgl_mulai, tgl_selesai, lokasi, foto_banner) VALUES
(
    'Kerja Bakti Bersih Desa & Saluran Irigasi',
    'Gotong royong warga membersihkan jalan poros desa, selokan, dan saluran irigasi sawah menyambut musim tanam.',
    '2026-11-08 07:00:00',
    '2026-11-08 11:30:00',
    'Sepanjang Jalan Poros RW 01 - RW 03',
    'https://images.unsplash.com/photo-1593113598332-cd288d649433'
),
(
    'Posyandu Balita & Skrining Kesehatan Lansia',
    'Pemeriksaan rutin tumbuh kembang balita, imunisasi dasar, serta cek tekanan darah dan gula darah gratis untuk lansia.',
    '2026-11-12 08:30:00',
    '2026-11-12 12:00:00',
    'Balai Posyandu Mawar, Dusun Sukamaju',
    'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982'
),
(
    'Musyawarah Rencana Pembangunan Desa (Musrenbangdes)',
    'Rapat koordinasi kepala desa, perangkat, BPD, dan tokoh masyarakat untuk penetapan skala prioritas pembangunan tahun depan.',
    '2026-11-18 19:30:00',
    '2026-11-18 22:30:00',
    'Balai Desa Mandiri',
    'https://images.unsplash.com/photo-1577962917302-cd874c4e31d2'
),
(
    'Turnamen Bola Voli Antar-Dusun',
    'Ajang silaturahmi dan olahraga pemuda karang taruna mempertemukan tim terbaik dari masing-masing dusun.',
    '2026-11-21 14:00:00',
    '2026-11-22 17:30:00',
    'Lapangan Voli Dusun Krajan',
    'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1'
),
(
    'Penyuluhan Pengendalian Hama Padi & Pupuk Organik',
    'Pelatihan dari petugas penyuluh pertanian lapangan (PPL) mengenai pembuatan pupuk cair mandiri dan pencegahan hama wereng.',
    '2026-11-26 09:00:00',
    '2026-11-26 12:30:00',
    'Gazebo Pertemuan Kelompok Tani Tunas Harapan',
    'https://images.unsplash.com/photo-1592982537447-7440770cbfc9'
),
(
    'Pengajian Akbar & Santunan Anak Yatim',
    'Peringatan hari besar keagamaan diisi tausiyah ulama kecamatan dan pemberian santunan bagi warga kurang mampu.',
    '2026-12-04 19:00:00',
    '2026-12-04 22:00:00',
    'Masjid Jami Al-Hidayah, Dusun Selatan',
    'https://images.unsplash.com/photo-1542810634-71277d95dcbb'
),
(
    'Penyaluran Bantuan Langsung Tunai Dana Desa (BLT-DD)',
    'Pembagian bantuan tunai tahap akhir tahun bagi keluarga penerima manfaat yang terdata di sistem kependudukan desa.',
    '2026-12-10 08:00:00',
    '2026-12-10 14:00:00',
    'Pendopo Kantor Kepala Desa',
    'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c'
);