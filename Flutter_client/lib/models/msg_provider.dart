import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';

class MessageModel extends ChangeNotifier {
  List<Message> _messages_group_one = [
    Message(
      sender: black_panter,
      time: '5:30 PM',
      text: 'Hey dude! Even dead I\'m the hero. Love you 3000 guys.',
      unread: true,
    )
  ];
  void add(Message message) {
    print("coming${message.text}");
    _messages_group_one.add(message);
    _messages_group_one.forEach((element) {
      print(element.text);
    });
    notifyListeners();
  }

  List<Message> get messages => _messages_group_one;
}
