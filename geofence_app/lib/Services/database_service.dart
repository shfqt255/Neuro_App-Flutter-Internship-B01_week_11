import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> init() async {
    if (_db != null) return _db!;

    _db = await openDatabase(
      join(await getDatabasesPath(), 'location.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE locations(id INTEGER PRIMARY KEY, lat REAL, lng REAL, time TEXT)",
        );
      },
      version: 1,
    );

    return _db!;
  }

  static Future insert(double lat, double lng) async {
    final db = await init();

    await db.insert('locations', {
      'lat': lat,
      'lng': lng,
      'time': DateTime.now().toString(),
    });
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await init();
    return db.query('locations', orderBy: 'id DESC');
  }
}
