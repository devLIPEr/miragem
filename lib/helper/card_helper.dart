import 'dart:async';

import 'package:miragem/helper/collection_helper.dart';
import 'package:sqflite/sqflite.dart';

String cardTable = "cardTable";
String collectionIdColumn = "collectionIdColumn";
String idColumn = "idColumn";
String nameColumn = "nameColumn";
String qualityColumn = "qualityColumn";
String quantityColumn = "quantityColumn";
String idiomColumn = "idiomColumn";
String imageColumn = "imageColumn";

class CardHelper {
  static final CardHelper _instance = CardHelper.internal();
  factory CardHelper() => _instance;
  CardHelper.internal();

  Future<Database> get db async {
    return CollectionHelper().db;
  }

  Future<List<Card>> getAllCards(int collectionId) async {
    Database dbCollection = await db;
    List listMap = await dbCollection.rawQuery(
        "SELECT * FROM $cardTable WHERE $collectionIdColumn = $collectionId;");
    List<Card> listCard = [];
    for (Map m in listMap) {
      listCard.add(Card.fromMap(m));
    }
    return listCard;
  }

  Future<List<Card>> getAllCardsOfAllCollections() async {
    Database dbCollection = await db;
    List listMap = await dbCollection.rawQuery("SELECT * FROM $cardTable;");
    List<Card> listCard = [];
    for (Map m in listMap) {
      listCard.add(Card.fromMap(m));
    }
    return listCard;
  }

  Future<Card> getCard(int id) async {
    Database dbCollection = await db;
    List<Map> maps = await dbCollection.query(
      cardTable,
      columns: [
        idColumn,
        nameColumn,
        qualityColumn,
        quantityColumn,
        idiomColumn,
        imageColumn,
        collectionIdColumn
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Card.fromMap(maps.first);
    }
    return null;
  }

  Future<Card> saveCard(Card card) async {
    Database dbCollection = await db;
    card.id = await dbCollection.insert(cardTable, card.toMap());
    return card;
  }

  Future<int> updateCard(Card card) async {
    Database dbCollection = await db;
    return await dbCollection.update(cardTable, card.toMap(),
        where: "$idColumn = ?", whereArgs: [card.id]);
  }

  Future<int> deleteCard(int id) async {
    Database dbCollection = await db;
    return await dbCollection
        .delete(cardTable, where: "$idColumn = ?", whereArgs: [id]);
  }
}

class Card {
  Card();

  int id;
  int collectionId;
  String name;
  Quality quality;
  int quantity;
  Idiom idiom;
  String img;

  Card.fromMap(Map map) {
    id = map[idColumn];
    collectionId = map[collectionIdColumn];
    name = map[nameColumn];
    quality = Quality.values[map[qualityColumn]];
    quantity = map[quantityColumn];
    idiom = Idiom.values[map[idiomColumn]];
    img = map[imageColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      collectionIdColumn: collectionId,
      nameColumn: name,
      qualityColumn: quality.index,
      quantityColumn: quantity,
      idiomColumn: idiom.index,
      imageColumn: img,
    };

    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Card(id: $id, collection: $collectionId, name: $name, quantity: $quantity, quality: $quality, idiom: $idiom, image: $img)";
  }
}

enum Quality { M, NM, SP, MP, HP, D }

enum Idiom { PT, EN, JP }
