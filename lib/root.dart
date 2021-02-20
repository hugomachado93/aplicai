
import 'package:aplicai/home_page.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
  
}

class _RootPageState extends State<RootPage> {

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }

}