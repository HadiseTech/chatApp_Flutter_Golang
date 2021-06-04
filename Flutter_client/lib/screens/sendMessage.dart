import 'dart:convert';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/msg_provider.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// class SendMessage extends StatefulWidget {
//   final WebSocketChannel channel;
//   SendMessage({this.channel});
//   @override
//   _SendMessageState createState() => _SendMessageState();
// }

// class _SendMessageState extends State<SendMessage> {
// }
class SendMessage extends StatelessWidget {
  final WebSocketChannel channel;
  SendMessage({this.channel});

  final fieldText = TextEditingController();
  String _message;
  @override
  Widget build(BuildContext context) {
    return Consumer<MessageModel>(
      builder: (context, model, _) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 70,
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.photo),
                iconSize: 25,
                color: Theme.of(context).primaryColor,
                onPressed: () {}),
            Expanded(
              child: TextField(
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
                textCapitalization: TextCapitalization.sentences,
                controller: fieldText,
                onChanged: (value) {
                  // setState(() {
                  //   _message = value;
                  // });
                },
              ),
            ),
            IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_message != '') {
                    Message message = Message(
                        sender: currentUser,
                        text: fieldText.text,
                        time: '1:10 am',
                        unread: true);
                    print("Adding ${message.text}");
                    context.read<MessageModel>().add(message);
                    final messageJson = jsonEncode({"Message": fieldText.text});
                    channel.sink.add(messageJson);
                    fieldText.clear();
                  }
                })
          ],
        ),
      )
    );
  }
}
