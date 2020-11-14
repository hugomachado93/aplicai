import 'package:aplicai/pages/explore_page.dart';
import 'package:aplicai/pages/user_profile.dart';
import 'package:flutter/material.dart';

import 'em_andamento_page.dart';
import 'notification_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<NavigationPage> {
  int _selectedIndex = 0;
  List<Widget> _widgetsOptions = <Widget>[ExplorePage(), EmAndamentoPage(), NotificationPage(), UserProfilePage()];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      body: _widgetsOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Em andamento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
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
      ),
    );
  }
}
