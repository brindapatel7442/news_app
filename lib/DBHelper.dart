import 'dart:async';
import 'dart:io' as io;
import 'package:news_app/models/headline.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static late Database _db;
  static const String dbName = 'news_app.db'; // local Database name

  // Fields for Headline
  static const String table = 'headline';
  static const String id = 'id';
  static const String title = 'title';
  static const String image = 'image';
  static const String author = 'author';
  static const String publishedAt = 'publishedAt';
  static const String description = 'description';

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path, version:3, onCreate: _onCreate,onUpgrade:_onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    // Create all tables
    await db.execute("CREATE TABLE $table ($id INTEGER PRIMARY KEY AUTOINCREMENT, $title VARCHAR, $image VARCHAR, $author VARCHAR,"
        " $publishedAt VARCHAR, $description TEXT)");
  }

  // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {

    }
  }

  //  Save headline
  Future<void> save(Headlines headlines) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(table, columns: [title],  where: '$title = ?', whereArgs: [headlines.title]);
    if(maps.isEmpty) {
      await dbClient.insert(table, headlines.toMap());
    }
  }

  // Get all headline list
  Future<List<Headlines>> getHeadlines() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(table, columns: [id, title,image,author,publishedAt,description]);
    List<Headlines> posts = [];
      for (int i = 0; i < maps.length; i++) {
        posts.add(Headlines(
            title:maps[i][title],
            image:maps[i][image],
            author:maps[i][author],
            publishedAt:maps[i][publishedAt],
            description:maps[i][description]));
      }
    return posts;
  }

}
