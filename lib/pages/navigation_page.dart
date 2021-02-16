import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/pages/explore_page.dart';
import 'package:aplicai/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:provider/provider.dart';

import 'em_andamento_page.dart';
import 'notification_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<NavigationPage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  UserService userService = UserService();

  int _selectedIndex = 0;
  List<Widget> _widgetsOptions = <Widget>[
    ExplorePage(),
    EmAndamentoPage(),
    NotificationPage(),
    UserProfilePage()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(Object context) {
    var userEntity = Provider.of<UserEntity>(context);
      return Scaffold(
          body: _widgetsOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Explorar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Em andamento',
              ),
              BottomNavigationBarItem(
                icon: StreamBuilder<int>(
                    initialData: 0,
                    stream: userService.getUserNumNotifications(userEntity),
                    builder: (context, snapshot) {
                      return snapshot.data == 0
                          ? Icon(Icons.school)
                          : Badge(
                              badgeContent: Text(snapshot.data.toString()),
                              position:
                                  BadgePosition.topEnd(top: -10, end: -10),
                              child: Icon(Icons.school));
                    }),
                label: 'Notificações',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Perfil',
              )
            ],
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
          ));
  }
}
