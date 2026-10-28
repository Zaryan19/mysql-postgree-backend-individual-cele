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