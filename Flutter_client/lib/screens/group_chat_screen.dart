import 'package:chat_app/models/group_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  final Group group;
  GroupChat({this.group});
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  List<Message> messages;
  @override
  void initState() {
    // TODO: implement initState
    messages = widget.group.id == 0 ? messages_group_one : messages_group_two;
    super.initState();
  }

  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  _chatBubble(Message message, bool isMe, bool isSameUser) {
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
              !isSameUser
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          message.time,
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
                    message.text,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              !isSameUser
                  ? Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5)
                              ]),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage(message.sender.imageUrl),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          message.time,
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
                  Message message = Message(
                      sender: currentUser,
                      text: _message,
                      time: '1:10 am',
                      unread: true);
                  clearText();
                  // messages.add(message);
                  messages.insert(0, message);
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
  Widget build(BuildContext context) {
    int prevUserId;
    return Scaffold(
        backgroundColor: Color(0xFFF6F6f6),
        appBar: AppBar(
          centerTitle: true,
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: widget.group.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              TextSpan(text: '\n'),
              TextSpan(
                  text: '${widget.group.member} Online',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400))
            ]),
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
                child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages[index];
                      final isMe = message.sender.id == currentUser.id;
                      final bool isSameUser = prevUserId == message.sender.id;
                      prevUserId = message.sender.id;
                      return _chatBubble(message, isMe, isSameUser);
                    })),
            Container(
              child: _sendMessageArea(),
            )
          ],
        ));
  }
}
