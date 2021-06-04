import 'dart:convert';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/msg_provider.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/sendMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// class ChatScreen extends StatefulWidget {
//   final User user;
//   final WebSocketChannel channel;

//   const ChatScreen({this.user, this.channel});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {

// }

class ChatScreen extends StatelessWidget {
  final User user;
  final WebSocketChannel channel;

  const ChatScreen({this.user, this.channel});

  _chatBubble(
      Message message, bool isMe, bool isSameUser, BuildContext context) {
    if (isMe) {
      return Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topRight,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80),
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5)
                      ]),
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // ? Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(
              //         message.text,
              //         style: TextStyle(fontSize: 12, color: Colors.black45),
              //       ),
              //       SizedBox(
              //         width: 10.0,
              //       ),
              //       // Container(
              //       //   decoration: BoxDecoration(
              //       //       shape: BoxShape.circle,
              //       //       boxShadow: [
              //       //         BoxShadow(
              //       //             color: Colors.grey.withOpacity(0.5),
              //       //             spreadRadius: 2,
              //       //             blurRadius: 5)
              //       //       ]),
              //       //   child: CircleAvatar(
              //       //     radius: 15,
              //       //     backgroundImage:
              //       //         AssetImage(message.sender.imageUrl),
              //       //   ),
              //       // ),
              //     ],
              //   )
              // Container(
              //     child: null,
              //   )
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80),
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5)
                      ]),
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              // !isSameUser
              //     ? Row(
              //         children: [
              // Container(
              //   decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.grey.withOpacity(0.5),
              //             spreadRadius: 2,
              //             blurRadius: 5)
              //       ]),
              //   child: CircleAvatar(
              //     radius: 15,
              //     backgroundImage:
              //         AssetImage(message.sender.imageUrl),
              //   ),
              // ),
              //       SizedBox(
              //         width: 10.0,
              //       ),
              //       Text(
              //         message.text,
              //         style: TextStyle(fontSize: 12, color: Colors.black45),
              //       )
              //     ],
              //   )
              // : Container(
              //     child: null,
              //   )
            ],
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    Message message;
    int prevUserId;
    return Scaffold(
        backgroundColor: Color(0xFFF6F6f6),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(user.imageUrl),
              ),
              SizedBox(
                width: 30,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: user.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  TextSpan(text: '\n'),
                  user.isOnline
                      ? TextSpan(
                          text: 'Online',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w400))
                      : TextSpan(
                          text: 'Offline',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w400)),
                ]),
              ),
            ],
          ),
          leading: IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Consumer<MessageModel>(
                    builder: (context, model, _) => StreamBuilder(
                        // reverse: true,
                        // padding: EdgeInsets.all(10),
                        stream: channel.stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          // String message = '';
                          if (snapshot.hasData) {
                            Map<String, dynamic> jsonData =
                                jsonDecode(snapshot.data);
                            print("Kind ${jsonData["Type"]}");
                            if (jsonData["Type"] != "end") {
                              Message message = Message(
                                  sender: thor,
                                  text: jsonData["Message"],
                                  time: '1:10 am',
                                  unread: true);

                              context.read<MessageModel>().add(message);
                              // snapshot.data;
                            }
                          }
                          return ListView.builder(
                              itemCount: model.messages.length,
                              itemBuilder: (context, idx) {
                                final isMe = model.messages[idx].sender.id ==
                                    currentUser.id;
                                final bool isSameUser =
                                    prevUserId == model.messages[idx].sender.id;
                                prevUserId = model.messages[idx].sender.id;
                                return _chatBubble(model.messages[idx], isMe,
                                    isSameUser, context);
                              });
                        }))),
            Container(
              child: SendMessage(
                channel: channel,
              ),
            )
          ],
        ));
  }
}
