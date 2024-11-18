import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String collectionTable = "collectionTable";
String idColumn = "idColumn";
String nameColumn = "nameColumn";
String amountColumn = "amountColumn";
String imageColumn = "imageColumn";

class CollectionHelper {
  static final CollectionHelper _instance = CollectionHelper.internal();
  factory CollectionHelper() => _instance;
  CollectionHelper.internal();
  Database _db;

  Future<Database> get db async {
    _db ??= await initdb();
    // _db.execute("DROP TABLE $collectionTable");
    // _db.execute(
    //     "CREATE TABLE $collectionTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT NOT NULL, $amountColumn INTEGER NOT NULL DEFAULT (0), $imageColumn TEXT)");
    return _db;
  }

  Future<Database> initdb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "collections.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute(
            "CREATE TABLE $collectionTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT NOT NULL, $amountColumn INTEGER NOT NULL DEFAULT (0), $imageColumn TEXT)");
      },
    );
  }

  Future<List<Collection>> getAllCollections() async {
    Database dbCollection = await db;
    List listMap =
        await dbCollection.rawQuery("SELECT * FROM $collectionTable");
    List<Collection> listCollection = [];
    for (Map m in listMap) {
      listCollection.add(Collection.fromMap(m));
    }
    return listCollection;
  }

  Future<Collection> getCollection(int id) async {
    Database dbCollection = await db;
    List<Map> maps = await dbCollection.query(
      collectionTable,
      columns: [idColumn, nameColumn, amountColumn, imageColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Collection.fromMap(maps.first);
    }
    return null;
  }

  Future<Collection> saveCollection(Collection collection) async {
    Database dbCollection = await db;
    collection.id =
        await dbCollection.insert(collectionTable, collection.toMap());
    return collection;
  }

  Future<int> updateCollection(Collection collection) async {
    Database dbCollection = await db;
    return await dbCollection.update(collectionTable, collection.toMap(),
        where: "$idColumn = ?", whereArgs: [collection.id]);
  }

  Future<int> deleteCollection(int id) async {
    Database dbCollection = await db;
    return await dbCollection
        .delete(collectionTable, where: "$idColumn = ?", whereArgs: [id]);
  }
}

class Collection {
  Collection();

  int id;
  int amount;
  String name;
  String image;

  Collection.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    amount = map[amountColumn];
    image = map[imageColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nameColumn: name,
      amountColumn: amount,
      imageColumn: image,
    };

    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Collection(id: $id, name: $name, amount: $amount, image: $image)";
  }
}
