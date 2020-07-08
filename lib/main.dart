import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tada_test_chat/chat.dart';
import 'package:tada_test_chat/constants.dart';
import 'package:tada_test_chat/styles.dart';
import 'Database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tada',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        hintColor: hintTextColor,
        cursorColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getMaxId() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('maxId')) {
      maxId = prefs.getInt('maxId');
    } else {
      maxId = 0;
      await prefs.setInt('maxId', 0);
    }
  }

  preloader() async {
    await getMaxId();
    await DatabaseMessages().openData();
    messages = await DatabaseMessages().getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: preloader(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return ChatPage();
            }
            break;
          default:
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
        }
      },
    );
  }
}
