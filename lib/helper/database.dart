import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database = null;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    // buat database dan tabel
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'my_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE my_table(id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT, value TEXT)',
        );
      },
      version: 1,
    );
  }

  // tambahkan data ke tabel
  Future<int> insertData(String key, String value) async {
    final db = await database;
    final insertionData = {
      'key': key,
      'value': value,
    };

    // return kalo data kosong
    if (db == null) return 0;
    List prevData = await db.query(
      'my_table',
      where: 'key  = ?',
      whereArgs: [key],
    );

    // kalo data dengan key yang dikasih sudah ada
    // update data di db instead of insert data
    if (prevData.isNotEmpty) {
      return await db.update(
        'my_table',
        insertionData,
        where: 'key  = ?',
        whereArgs: [key],
      );
    }

    // insert data ke db
    return await db.insert('my_table', insertionData);
  }

  // ambil data dari tabel
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    if (db == null) return [];
    return await db.query('my_table', columns: ['key', 'value']);
  }
}
