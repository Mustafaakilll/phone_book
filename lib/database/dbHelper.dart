import 'dart:async';
import 'package:path/path.dart';
import 'package:phone_book_deneme/model/contact.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Contact.db");

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "Create Table Contact(id integer Primary Key,name Text,number Text)");
  }

  Future<List<Contact>> getContact() async {
    var dbClient = await this.db;
    var result = await dbClient.query("Contact", orderBy: "name");
    return List.generate(result.length, (index) {
      return Contact.fromMap(result[index]);
    });
  }

  Future<int> insertContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.insert("Contact", contact.toMap());
  }

  Future<int> updateContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.update("Contact", contact.toMap(),
        where: "id=?", whereArgs: [contact.id]);
  }

  Future<int> removeContact(int id) async {
    var dbClient = await db;
    return await dbClient.delete("Contact", where: "id=?", whereArgs: [id]);
  }
}
