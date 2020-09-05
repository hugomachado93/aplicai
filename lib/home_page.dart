import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool isLoading = false;

  Future _signIn(context) async {
    try {
      setState(() {
        isLoading = true;
      });

      var googleUser = await _googleSignIn.signIn();
      var googleAuth = await googleUser.authentication;
      var credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var authResult = await _firebaseAuth.signInWithCredential(credential);
      var user = authResult.user;

      var userData = await _db.collection("Users").doc(user.uid).get();

      setState(() {
        isLoading = false;
      });

      if (userData.data() != null) {
        print("usuario com login ${userData.data()}");
        Navigator.of(context).pushNamed("/signup-start");
      } else {
        print("usuario sem login ${userData.data()}");
        _db
            .collection("Users")
            .doc(user.uid)
            .set({"nome": user.displayName, "email": user.email});

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
