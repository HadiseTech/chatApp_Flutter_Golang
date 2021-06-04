import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class UsernameScreen extends StatefulWidget {

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  // final _username_text = TextEditingController();
  String _username = '';
  bool _exist = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: TextField(
                  
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                ),
              ),
              FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    if (!_exist) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HomeScreen(
                                    username: _username,
                                    channel: IOWebSocketChannel.connect(
                                        'ws://192.168.137.1:8080/ws?username=$_username}'),
                                  )));
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Username Exist"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('return'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                    }
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
