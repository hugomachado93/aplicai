
import 'package:aplicai/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity/user_entity.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
  
}

class _RootPageState extends State<RootPage> {

  @override
  Widget build(BuildContext context) {
    var userEntity = Provider.of<UserEntity>(context);
    return (userEntity != null) ? HomePage() : Container();
  }

}