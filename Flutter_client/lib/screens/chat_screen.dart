import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final WebSocketChannel channel;

  const ChatScreen({this.user, this.channel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  _chatBubble(String message, bool isMe, bool isSameUser) {
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
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              !isSameUser
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          message,
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
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
                      ],
                    )
                  : Container(
                      child: null,
                    )
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
                    message,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              !isSameUser
                  ? Row(
                      children: [
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
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          message,
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        )
                      ],
                    )
                  : Container(
                      child: null,
                    )
            ],
          ),
        ],
      );
    }
  }

  String _message = '';
  _sendMessageArea() {
    return Container(
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
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              textCapitalization: TextCapitalization.sentences,
              controller: fieldText,
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: () {
                if (_message != '') {
                  // Message message = Message(
                  //     sender: currentUser,
                  //     text: _message,
                  //     time: '1:10 am',
                  //     unread: true);
                  clearText();
                  // messages.add(message);
                  widget.channel.sink.add(_message);
                  setState(() {
                    _message = '';
                  });
                }
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: AssetImage(widget.user.imageUrl),
              ),
              SizedBox(
                width: 30,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: widget.user.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  TextSpan(text: '\n'),
                  widget.user.isOnline
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
                child: StreamBuilder(
                    // reverse: true,
                    // padding: EdgeInsets.all(10),
                    stream: widget.channel.stream,
                    builder: (context, snapshot) {
                      final message =
                          snapshot.hasData ? '${snapshot.data}' : "No Message";
                      // final isMe = message.sender.id == currentUser.id;
                      // final bool isSameUser = prevUserId == message.sender.id;
                      // prevUserId = message.sender.id;
                      return _chatBubble(message, true, true);
                    })),
            Container(
              child: _sendMessageArea(),
            )
          ],
        ));
  }
}
