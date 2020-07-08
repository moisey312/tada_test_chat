import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';

class Message {
  DateTime created;
  String name;
  String text;
  int status;
  int id;

  Message(this.id, this.created, this.name, this.text, this.status);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'name': name,
      'text': text,
      'status': status
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'name': name,
      'text': text,
      'status': status
    };
  }

  Message.fromJson(Map json, int status, int id)
      : this.id = id,
        created = DateTime.parse(json['created']),
        name = json['name'],
        text = json['text'],
        this.status = status;

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    return this.text == text && this.name == name;
  }

  @override
  int get hashCode => super.hashCode;
}

class DatabaseMessages {
  Future<void> insertMessage(Message message) async {
    final Database db = await database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  openData() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'messages_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE messages(id INTEGER PRIMARY KEY, created TEXT, name TEXT, text TEXT, status INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<List<Message>> getMessages() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return Message(maps[i]['id'], DateTime.parse(maps[i]['created']),
          maps[i]['name'], maps[i]['text'], maps[i]['status']);
    });
  }

  Future<void> updateDog(Message message) async {
    final db = await database;

    await db.update(
      'messages',
      message.toMap(),
      where: "id = ?",
      whereArgs: [message.id],
    );
  }
}
