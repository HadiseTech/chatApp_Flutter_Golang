import 'package:chat_app/models/msg_provider.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/usernam_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(
   MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MessageModel())],
      child: MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo', 
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF01afbd),
      ),
      home: UsernameScreen(),
    );
  }
}

