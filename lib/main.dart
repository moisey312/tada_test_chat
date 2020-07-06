import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tada_test_chat/constants.dart';
import 'package:tada_test_chat/message.dart';
import 'package:tada_test_chat/styles.dart';
import 'package:websocket_manager/websocket_manager.dart';

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
        cursorColor: Colors.white
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
  WebsocketManager websocketManager;
  TextEditingController textController;
  final List<Message> messages = [];
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 50.0);
    textController = TextEditingController();
    websocketManager = WebsocketManager('ws://pm.tada.team/ws?name=test123');
    websocketManager.connect();
    websocketManager.onMessage((event){
      setState(() {
        Message message = Message.fromJson(json.decode(event));
        messages.add(message);
        if(message.name == name){
          setState(() {
            canSend = true;
          });
        }
        if (scrollController.hasClients)
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(
              milliseconds: 500,
            ),
            curve: Curves.ease,
          );
      });
    });
  }

  void sendData() {
    if (textController.text.isNotEmpty) {
      websocketManager.send('{' + '\"text\":' + '\"' + textController.text + '\"' + '}');
      textController.text = "";
      setState(() {
        canSend = false;
      });
    }
  }

  @override
  void dispose() {
    websocketManager.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'чат',
          ),
        ),
      ),
      body: Container(
        color: Colors.black54,
        child: Column(
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
                          border: Border.all(width: 1, color: hintBorderColor,),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: hintBackColor,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Form(
                                child: TextFormField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    hintText: 'Сообщение...',
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      value.length==0?hasText=false:hasText=true;
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
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: hasText&&canSend?sendBackColor:sendOffIconColor, shape: BoxShape.circle),
                        child: Icon(
                          Icons.send,
                          color: sendOnIconColor,
                        ),
                      ),
                      onTap: () {
                        if(hasText && canSend)
                        sendData();
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
