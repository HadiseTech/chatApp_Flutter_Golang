import 'package:chat_app/models/group_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/group_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/home_drawer.dart';
import 'package:web_socket_channel/io.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = true;
  List _filtedChat = [];
  List _filterdGroup = [];
  @override
  void initState() {
    setState(() {
      _filtedChat = chats;
      _filterdGroup = groups;
    });
    super.initState();
  }

  void _filterChat(value) {
    print(value);
    print(chats[0].sender.name);
    setState(() {
      _filtedChat = chats
          .where((element) => element.sender.name
              .toLowerCase()
              .contains(value.toString().toLowerCase()))
          .toList();
    });
    _filterdGroup = groups
        .where((group) =>
            group.name.toLowerCase().contains(value.toString().toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person, color: Colors.white),
                ),
                Tab(
                  icon: Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            elevation: 8,
            title: isSearching
                ? Text(
                    'Inbox',
                    style: TextStyle(color: Colors.white),
                  )
                : TextField(
                    onChanged: (value) {
                      _filterChat(value);
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        // border: OutlineInputBorder(),
                        hintText: "Search Inbox...",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              isSearching
                  ? IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      })
                  : IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                          _filtedChat = chats;
                          _filterdGroup = groups;
                        });
                      }),
            ],
          ),
          drawer: HomeDrawer(),
          body: TabBarView(
            children: [
              ListView.builder(
                  itemCount: _filtedChat.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Message chat = _filtedChat[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                user: chat.sender,
                                channel: IOWebSocketChannel.connect('wss://echo.websocket.org'),
                                ))),
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: chat.unread
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                        border: Border.all(
                                            width: 2,
                                            color:
                                                Theme.of(context).primaryColor),
                                        // shape: BoxShape.circle,
                                        boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5)
                                          ])
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5)
                                          ]),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage(chat.sender.imageUrl),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              chat.sender.name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            chat.sender.isOnline
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    width: 7,
                                                    height: 7,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )
                                                : Container(
                                                    child: null,
                                                  )
                                          ],
                                        ),
                                        Text(
                                          chat.time,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        chat.text,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    );
                  }),
              ListView.builder(
                  itemCount: _filterdGroup.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  GroupChat(group: _filterdGroup[index]))),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2, left: 15, top: 10),
                        // padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 35,
                                child: Text(
                                  "G$index",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_filterdGroup[index].name}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      child: Row(
                                    children: [
                                      Text(
                                        "Hot ${_filterdGroup[index].id} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "I am with the sun glass.",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
            ],
          )),
    );
  }
}
