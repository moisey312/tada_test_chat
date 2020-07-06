import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tada_test_chat/constants.dart';
import 'package:tada_test_chat/styles.dart';

class Message {
  DateTime created;
  String name;
  String text;
  Map<String, dynamic> toMap() {
    return {
      'created': created,
      'name': name,
      'text': text,
    };
  }
  Message.fromJson(Map json)
      : created = DateTime.parse(json['created']),
        name = json['name'],
        text = json['text'];

}

class MessageWidget extends StatefulWidget {
  MessageWidget(this.text, this.name, this.date);

  final String text;
  final String name;
  final DateTime date;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.name == name ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: widget.name == name? EdgeInsets.only(top:5.0, bottom: 5.0, left: width/5, right: 10):EdgeInsets.only(top:5.0, bottom: 5.0, left: 10, right: width/5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: colorOfMessage,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NullNameMessageWidget extends StatefulWidget {
  NullNameMessageWidget(this.text, this.date);

  String text;
  DateTime date;

  @override
  _NullNameMessageWidgetState createState() => _NullNameMessageWidgetState();
}

class _NullNameMessageWidgetState extends State<NullNameMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0, bottom: 5.0, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: colorOfMessage,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
