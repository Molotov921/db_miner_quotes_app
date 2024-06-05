import 'package:db_miner_quotes_app/models/quotes_model.dart';
import 'package:db_miner_quotes_app/views/home/homepage_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quotes.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quotes(
        id INTEGER PRIMARY KEY,
        quote TEXT,
        author TEXT
      )
      ''');
  }

  Future<void> insertQuote(Quote quote) async {
    final db = await database;
    await db.insert('quotes', quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // Notify GetX to update the quotes list
    Get.find<QuoteController>().fetchData();
  }

  Future<List<Quote>> getQuotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('quotes');
    return List.generate(
      maps.length,
      (i) {
        return Quote(
          id: maps[i]['id'],
          quote: maps[i]['quote'],
          author: maps[i]['author'],
          isFavorite: false.obs,
        );
      },
    );
  }

  Future<int> deleteQuote(int id) async {
    Database db = await instance.database;
    int deletedRows =
        await db.delete('quotes', where: 'id = ?', whereArgs: [id]);
    Get.find<QuoteController>().fetchData();
    return deletedRows;
  }
}
