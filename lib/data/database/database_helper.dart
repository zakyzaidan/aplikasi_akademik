import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'akademik.db');

    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabel SISWA
    await db.execute('''
      CREATE TABLE siswa (
        nis TEXT PRIMARY KEY,
        nama VARCHAR(50) NOT NULL,
        alamat VARCHAR(100) NOT NULL
      )
    ''');

    // Tabel MATA_PELAJARAN
    await db.execute('''
      CREATE TABLE mata_pelajaran (
        id_matpel INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_matpel VARCHAR(50) NOT NULL
      )
    ''');

    // Tabel UJIAN
    await db.execute('''
      CREATE TABLE ujian (
        id_ujian INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_ujian VARCHAR(50) NOT NULL,
        id_matpel INTEGER NOT NULL,
        tanggal DATETIME NOT NULL,
        FOREIGN KEY (id_matpel) REFERENCES mata_pelajaran(id_matpel)
      )
    ''');

    // Tabel PESERTA (Nilai Ujian)
    await db.execute('''
      CREATE TABLE peserta (
        id_peserta INTEGER PRIMARY KEY AUTOINCREMENT,
        id_ujian INTEGER NOT NULL,
        nis TEXT NOT NULL,
        nilai_ujian DOUBLE NOT NULL,
        status_lulus TEXT DEFAULT 'BELUM DIPROSES',
        FOREIGN KEY (id_ujian) REFERENCES ujian(id_ujian),
        FOREIGN KEY (nis) REFERENCES siswa(nis)
      )
    ''');
  }

  // ==================== SISWA CRUD ====================
  Future<int> insertSiswa(Map<String, dynamic> siswa) async {
    final db = await database;
    return await db.insert('siswa', siswa);
  }

  Future<List<Map<String, dynamic>>> getAllSiswa() async {
    final db = await database;
    return await db.query('siswa');
  }

  Future<Map<String, dynamic>?> getSiswaByNis(String nis) async {
    final db = await database;
    final result = await db.query('siswa', where: 'nis = ?', whereArgs: [nis]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateSiswa(Map<String, dynamic> siswa) async {
    final db = await database;
    return await db.update(
      'siswa',
      siswa,
      where: 'nis = ?',
      whereArgs: [siswa['nis']],
    );
  }

  Future<int> deleteSiswa(String nis) async {
    final db = await database;
    return await db.delete('siswa', where: 'nis = ?', whereArgs: [nis]);
  }

  // ==================== MATA PELAJARAN CRUD ====================
  Future<int> insertMataPelajaran(Map<String, dynamic> mataPelajaran) async {
    final db = await database;
    return await db.insert('mata_pelajaran', mataPelajaran);
  }

  Future<List<Map<String, dynamic>>> getAllMataPelajaran() async {
    final db = await database;
    return await db.query('mata_pelajaran');
  }

  Future<int> updateMataPelajaran(Map<String, dynamic> mataPelajaran) async {
    final db = await database;
    return await db.update(
      'mata_pelajaran',
      mataPelajaran,
      where: 'id_matpel = ?',
      whereArgs: [mataPelajaran['id_matpel']],
    );
  }

  Future<int> deleteMataPelajaran(int id) async {
    final db = await database;
    return await db.delete(
      'mata_pelajaran',
      where: 'id_matpel = ?',
      whereArgs: [id],
    );
  }

  // ==================== UJIAN CRUD ====================
  Future<int> insertUjian(Map<String, dynamic> ujian) async {
    final db = await database;

    // ✅ Validasi foreign key
    final matpelExists = await db.rawQuery(
      'SELECT 1 FROM mata_pelajaran WHERE id_matpel = ?',
      [ujian['id_matpel']],
    );

    if (matpelExists.isEmpty) {
      throw Exception(
        'Mata Pelajaran dengan ID ${ujian['id_matpel']} tidak ditemukan',
      );
    }

    // ✅ Jangan insert id_ujian (biarkan autoincrement)
    final dataToInsert = Map<String, dynamic>.from(ujian);
    dataToInsert.remove('id_ujian');

    try {
      final result = await db.insert('ujian', dataToInsert);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // ✅ BENAR - Include u.id_matpel
  Future<List<Map<String, dynamic>>> getAllUjian() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT u.id_ujian, u.nama_ujian, u.id_matpel, mp.nama_matpel, u.tanggal
    FROM ujian u
    JOIN mata_pelajaran mp ON u.id_matpel = mp.id_matpel
    ORDER BY u.tanggal DESC
  ''');
  }

  Future<List<Map<String, dynamic>>> getUjianByTanggal(String tanggal) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT u.id_ujian, u.nama_ujian, mp.nama_matpel, u.tanggal
      FROM ujian u
      JOIN mata_pelajaran mp ON u.id_matpel = mp.id_matpel
      WHERE DATE(u.tanggal) = ?
      ORDER BY u.tanggal DESC
    ''',
      [tanggal],
    );
  }

  Future<int> updateUjian(Map<String, dynamic> ujian) async {
    final db = await database;
    return await db.update(
      'ujian',
      ujian,
      where: 'id_ujian = ?',
      whereArgs: [ujian['id_ujian']],
    );
  }

  Future<int> deleteUjian(int id) async {
    final db = await database;
    return await db.delete('ujian', where: 'id_ujian = ?', whereArgs: [id]);
  }

  // ==================== PESERTA CRUD ====================
  Future<int> insertPeserta(Map<String, dynamic> peserta) async {
    final db = await database;
    return await db.insert('peserta', peserta);
  }

  Future<List<Map<String, dynamic>>> getPesertaByUjian(int idUjian) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT p.id_peserta, p.id_ujian, p.nis, s.nama, p.nilai_ujian, p.status_lulus
      FROM peserta p
      JOIN siswa s ON p.nis = s.nis
      WHERE p.id_ujian = ?
      ORDER BY s.nama
    ''',
      [idUjian],
    );
  }

  Future<int> updatePeserta(Map<String, dynamic> peserta) async {
    final db = await database;
    return await db.update(
      'peserta',
      peserta,
      where: 'id_peserta = ?',
      whereArgs: [peserta['id_peserta']],
    );
  }

  Future<int> deletePeserta(int id) async {
    final db = await database;
    return await db.delete('peserta', where: 'id_peserta = ?', whereArgs: [id]);
  }

  // ==================== OPERASI KELULUSAN ====================
  Future<void> prosesDeterminasiKelulusan(
    int idUjian,
    double nilaiMinimal,
  ) async {
    final db = await database;

    final pesertaList = await getPesertaByUjian(idUjian);

    for (var peserta in pesertaList) {
      final statusLulus = peserta['nilai_ujian'] >= nilaiMinimal
          ? 'LULUS'
          : 'TIDAK LULUS';

      await db.update(
        'peserta',
        {'status_lulus': statusLulus},
        where: 'id_peserta = ?',
        whereArgs: [peserta['id_peserta']],
      );
    }
  }

  // ==================== LAPORAN DATA ====================

  // Menampilkan NAMA_UJIAN, NAMA_MATPEL, TANGGAL, JUMLAH_PESERTA
  Future<List<Map<String, dynamic>>> getLaporanUjian() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        u.id_ujian,
        u.nama_ujian,
        mp.nama_matpel,
        u.tanggal,
        COUNT(p.id_peserta) as jumlah_peserta
      FROM ujian u
      JOIN mata_pelajaran mp ON u.id_matpel = mp.id_matpel
      LEFT JOIN peserta p ON u.id_ujian = p.id_ujian
      GROUP BY u.id_ujian, u.nama_ujian, mp.nama_matpel, u.tanggal
      ORDER BY u.tanggal DESC
    ''');
  }

  // Menampilkan Jumlah SISWA yang Lulus dalam semua Ujian
  Future<List<Map<String, dynamic>>> getLaporanSiswaLulus() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        s.nis,
        s.nama,
        COUNT(CASE WHEN p.status_lulus = 'LULUS' THEN 1 END) as jumlah_lulus,
        COUNT(CASE WHEN p.status_lulus = 'TIDAK LULUS' THEN 1 END) as jumlah_tidak_lulus,
        COUNT(p.id_peserta) as total_ujian
      FROM siswa s
      LEFT JOIN peserta p ON s.nis = p.nis
      GROUP BY s.nis, s.nama
      ORDER BY jumlah_lulus DESC, s.nama
    ''');
  }

  // Menampilkan siswa yang tidak lulus dan gagal pada Mata pelajaran apa
  Future<List<Map<String, dynamic>>> getLaporanSiswaGagal() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        s.nis,
        s.nama,
        mp.nama_matpel,
        u.nama_ujian,
        p.nilai_ujian,
        u.tanggal
      FROM peserta p
      JOIN siswa s ON p.nis = s.nis
      JOIN ujian u ON p.id_ujian = u.id_ujian
      JOIN mata_pelajaran mp ON u.id_matpel = mp.id_matpel
      WHERE p.status_lulus = 'TIDAK LULUS'
      ORDER BY s.nama, mp.nama_matpel, u.tanggal
    ''');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
