import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import 'Database.dart';
import 'constants.dart';
import 'message.dart';
import 'styles.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textController;
  ScrollController scrollController;

  // ignore: cancel_subscriptions
  StreamSubscription connectivitySubscription;
  FocusNode _node;

  @override
  void initState() {
    super.initState();
    print(messages);
    _node = FocusNode();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        if (mounted) {
          for (int i = 0; i < messages.length; i++) {
            if (messages[i].status == 0) {
              messages[i].status = -1;
            }
          }
          setState(() {
            networkOn = false;
          });
        }
      } else {
        if (mounted)
          setState(() {
            channel =
                IOWebSocketChannel.connect('ws://pm.tada.team/ws?name=test123');
            networkOn = true;
          });
      }
    });
    scrollController = ScrollController(initialScrollOffset: 50.0);
    textController = TextEditingController();
    channel = IOWebSocketChannel.connect('ws://pm.tada.team/ws?name=test123');
    channel.stream.handleError((onError) {
      print(onError.toString());
    });
    channel.stream.listen((event) {
      Message message = Message.fromJson(json.decode(event), 1, maxId);
      if (message.name == name) {
        print(message.text);
        for (int i = 0; i < messages.length; i++) {
          if (message == messages[i]) {
            setState(() {
              messages[i].status = 1;
              DatabaseMessages().updateDog(messages[i]);
            });
          }
        }
      } else {
        maxId += 1;
        prefs.setInt('maxId', maxId);
        setState(() {
          DatabaseMessages().insertMessage(message);
          messages.add(message);
        });
      }
      if (scrollController.hasClients)
        setState(() {
          Timer(
              Duration(milliseconds: 300),
              () => {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.ease,
                    )
                  });
        });
    }, onError: (error) {
      print(error.toString());
    });
  }

  void sendData() async {
    if (textController.text.isNotEmpty) {
      Message message = Message(
          maxId, DateTime.now(), name, textController.text, networkOn ? 0 : -1);
      channel.sink
          .add('{' + '\"text\":' + '\"' + textController.text + '\"' + '}');
      maxId += 1;
      await prefs.setInt('maxId', maxId);
      DatabaseMessages().insertMessage(message);
      setState(() {
        messages.add(message);
        if (scrollController.hasClients)
          Timer(
              Duration(milliseconds: 300),
              () => {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.ease,
                    )
                  });
      });
      textController.text = "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/background.jpg',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(
            child: Row(
              children: <Widget>[
                Text(
                  networkOn ? 'Подключено' : 'Подключение',
                ),
                networkOn
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messages.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        if (messages[index].name != null) {
                          return MessageWidget(
                            messages[index].text,
                            messages[index].name,
                            messages[index].created,
                            messages[index].id,
                          );
                        } else {
                          return NullNameMessageWidget(
                            messages[index].text,
                            messages[index].created,
                          );
                        }
                      },
                      reverse: false,
                      controller: scrollController,
                    ),
            ),
            Container(
              color: downPanelColor,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: hintBorderColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: hintBackColor,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Form(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: double.infinity,
                                    maxWidth: double.infinity,
                                    maxHeight: 110
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    reverse: true,

                                    child: TextFormField(
                                      controller: textController,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: 'Сообщение...',
                                      ),
                                      maxLines: null,
                                      focusNode: _node,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          value.length == 0
                                              ? hasText = false
                                              : hasText = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: hasText && canSend
                                ? sendBackColor
                                : sendOffIconColor,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.send,
                          color: sendOnIconColor,
                        ),
                      ),
                      onTap: () {
                        if (hasText) sendData();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
