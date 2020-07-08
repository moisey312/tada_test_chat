import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'Database.dart';

const String name = 'test123';
double width;
double height;
bool hasText = false;
bool canSend = true;
bool networkOn = false;
int maxId;
Future<Database> database;
SharedPreferences prefs;
List<Message> messages = [];
WebSocketChannel channel;
