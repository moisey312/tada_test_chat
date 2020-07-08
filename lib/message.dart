import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tada_test_chat/constants.dart';
import 'package:tada_test_chat/styles.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget(this.text, this.name, this.date, this.id);

  final String text;
  final String name;
  final DateTime date;
  final int id;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    String hour =
        (widget.date.hour < 10 ? "0" : "") + widget.date.hour.toString();
    String minute =
        (widget.date.minute < 10 ? "0" : "") + widget.date.minute.toString();
    return Align(
      alignment:
          widget.name == name ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: widget.name == name
            ? EdgeInsets.only(top: 5.0, bottom: 5.0, left: width / 5, right: 10)
            : EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 10, right: width / 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: InkWell(
            onTap: () {
              if (widget.name == name && messages[widget.id].status == -1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('AlertDialog Title'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Это сообщение не отправлено'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Нет'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Повторить'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            channel.sink.add('{' +
                                '\"text\":' +
                                '\"' +
                                widget.text +
                                '\"' +
                                '}');
                            print('{' +
                                '\"text\":' +
                                '\"' +
                                widget.text +
                                '\"' +
                                '}');
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
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
                    Row(
                      children: <Widget>[
                        Text(
                          hour + ':' + minute,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        widget.name == name
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: messages[widget.id].status == 0
                                    ? Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : Container(
                                        child: messages[widget.id].status == 1
                                            ? Icon(
                                                Icons.done_all,
                                                color: Colors.white,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child: Text(
                                                    '!',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                              )
                            : Container()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
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
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10, right: 10),
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
