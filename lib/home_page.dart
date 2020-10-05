import 'package:aplicai/service/auth_service.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  SharedPreferences prefs;

  bool isLoading = false;

  Future _signIn(context) async {
    try {
      setState(() {
        isLoading = true;
      });

      var userAuth = await authService.getUserUidAuth();
      UserEntity user = await userService.getUserById(userAuth.uid);

      if (user != null) {
        print("usuario já cadastrado ${user}");
        Navigator.of(context).pushNamed("/navigation");
      } else {
        print("usuario sem login ${user}");
        await userService.createInitialuserLogin(
            userAuth.uid, userAuth.displayName, userAuth.email);

        prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", userAuth.uid);
        Navigator.of(context).pushNamed("/signup-start");
      }
    } catch (ex) {
      print("Falha ao logar $ex");
    }
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: Text("Entrar com o google"),
                  onPressed: () {
                    _signIn(context);
                  }),
        ),
      ),
    );
  }
}
