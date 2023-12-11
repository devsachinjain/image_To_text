import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/images_model.dart';

class DatabaseHelper {
  // Database name
  static const _databaseName = "scannedData.db";
  static const _databaseVersion = 1;

  static const imagesTable = 'scannedImages';

  // card details field
  static const id = 'id';
  static const imagePath = "imagePath";
  static const imageText = "imageText";
  static const date = "date";
  static const bookmark = "bookmark";

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $imagesTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $imagePath TEXT NOT NULL,
            $imageText TEXT NOT NULL,
            $date TEXT NOT NULL,
            $bookmark TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertImage(ScannedImageModel data) async {
    Database db = await instance.database;
    debugPrint('insert Image called');
    return await db.insert(imagesTable, {
      'imageText': data.imageText,
      'imagePath': data.imagePath,
      'date': data.date,
      'bookmark': data.bookmark,
    });
  }

  Future<List<Map<String, dynamic>>> getAllImagesDate() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data = await db.query(imagesTable);
    return data;
  }

  Future<List<Map<String, dynamic>>> getPinedImagesDate() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data =
        await db.query(imagesTable, where: '$bookmark = ?', whereArgs: ['1']);
    return data;
  }

  Future<int> updateImageData(int imageId, String bookmarkStatus) async {
    Database db = await instance.database;
    int result = await db.rawUpdate(
        'UPDATE $imagesTable SET bookmark = ? WHERE $id = ?',
        [bookmarkStatus, imageId]);

    return result;
  }

  Future<int> deleteImage(int imageId) async {
    Database db = await instance.database;
    int result =
        await db.delete(imagesTable, where: '$id = ?', whereArgs: [imageId]);
    return result;
  }
}
