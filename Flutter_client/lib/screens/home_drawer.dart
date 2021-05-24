import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Fasikaw",
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text("fasikaw@gmail.com",
                style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/ironman.jpg'),
            ),
            arrowColor: Colors.purple,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Colors.blue, Colors.green]),
              // color: Colors.purpleAccent
            ),
          ),
          ListTile(
            leading: Icon(Icons.contact_page),
            title: Text('account'),
          ),
          ListTile(leading: Icon(Icons.settings), title: Text('settings')),
          // ListTile(
          //   leading: Icon(Icons.favorite),
          //   title: Text('favorite'),
          // ),
          Divider(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('FAQ'),
          ),
          Divider(
            height: 20,
          ),
          ListTile(
            trailing: Icon(Icons.close),
            title: Text('close'),
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
