// Mengimpor koneksi pool database PostgreSQL dari folder config
const pool = require('../config/db');

// 1. GET: Mengambil seluruh data agenda event desa
exports.getAllEvent = async (req, res) => {
  try {
    // Menjalankan query untuk mengambil seluruh event diurutkan dari id terkecil
    const result = await pool.query('SELECT * FROM event_desa ORDER BY id ASC');

    // Mengembalikan status 200 (OK) dan seluruh data event dalam format JSON
    res.status(200).json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    // Mengembalikan status 500 jika terjadi kendala pada server atau database
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// 2. GET by ID: Mengambil 1 data event berdasarkan parameter ID di URL
exports.getEventById = async (req, res) => {
  // Mengambil nilai id dari parameter request (req.params.id)
  const { id } = req.params;

  try {
    // Menggunakan parameterized query ($1) untuk mencegah celah SQL Injection
    const result = await pool.query('SELECT * FROM event_desa WHERE id = $1', [id]);

    // Validasi jika data event dengan ID tersebut tidak ditemukan
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Data event tidak ditemukan',
      });
    }

    // Mengembalikan 1 objek data event yang ditemukan
    res.status(200).json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// 3. POST: Menambahkan data agenda event desa baru ke database
exports.createEvent = async (req, res) => {
  // Mengekstrak field dari body JSON yang dikirimkan client
  const { nama_event, deskripsi, tgl_mulai, tgl_selesai, lokasi, foto_banner } = req.body;

  // Validasi kolom wajib (NOT NULL di tabel database)
  if (!nama_event || !tgl_mulai || !lokasi) {
    return res.status(400).json({
      success: false,
      message: 'Nama event, tanggal mulai, dan lokasi wajib diisi',
    });
  }

  try {
    // Query INSERT dengan klausa RETURNING * agar data yang baru disimpan langsung dikembalikan
    const query = `
      INSERT INTO event_desa (nama_event, deskripsi, tgl_mulai, tgl_selesai, lokasi, foto_banner)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
    `;
    const values = [
      nama_event,
      deskripsi || null,
      tgl_mulai,
      tgl_selesai || null,
      lokasi,
      foto_banner || null,
    ];
    const result = await pool.query(query, values);

    // Mengembalikan status 201 (Created) untuk data baru yang berhasil dibuat
    res.status(201).json({
      success: true,
      message: 'Event desa berhasil ditambahkan',
      data: result.rows[0],
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// 4. PUT: Memperbarui data event desa berdasarkan ID
exports.updateEvent = async (req, res) => {
  const { id } = req.params;
  const { nama_event, deskripsi, tgl_mulai, tgl_selesai, lokasi, foto_banner } = req.body;

  try {
    // Mengecek terlebih dahulu apakah data event yang ingin diubah benar-benar ada di tabel
    const checkEvent = await pool.query('SELECT * FROM event_desa WHERE id = $1', [id]);
    if (checkEvent.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Data event tidak ditemukan',
      });
    }

    // Menjalankan query UPDATE dan memperbarui waktu di updated_at
    const query = `
      UPDATE event_desa
      SET 
        nama_event = $1,
        deskripsi = $2,
        tgl_mulai = $3,
        tgl_selesai = $4,
        lokasi = $5,
        foto_banner = $6,
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $7
      RETURNING *
    `;
    const values = [
      nama_event,
      deskripsi,
      tgl_mulai,
      tgl_selesai,
      lokasi,
      foto_banner,
      id,
    ];
    const result = await pool.query(query, values);

    res.status(200).json({
      success: true,
      message: 'Data event desa berhasil diperbarui',
      data: result.rows[0],
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// 5. DELETE: Menghapus data event desa berdasarkan ID
exports.deleteEvent = async (req, res) => {
  const { id } = req.params;

  try {
    // Menjalankan query DELETE dengan klausa RETURNING * untuk memeriksa apakah baris terhapus
    const result = await pool.query('DELETE FROM event_desa WHERE id = $1 RETURNING *', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Data event tidak ditemukan',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Event desa berhasil dihapus',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};