import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserProfilePageState();
  }
}

class _UserProfilePageState extends State<UserProfilePage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [
      Icon(icon),
      Expanded(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
        ),
      )
    ]);
  }

  Future<UserEntity> _getUserInfo() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(userId).get();
    return UserEntity.fromJson(documentSnapshot.data());
  }

  Widget _createTop(AsyncSnapshot<UserEntity> snapshot) {
    return Row(children: [
      Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: NetworkImage(snapshot.data.urlImage), fit: BoxFit.fill)),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(snapshot.data.name),
          Divider(color: Colors.black),
          _textBuilder(Icons.school, snapshot.data.curso),
          _textBuilder(Icons.date_range, snapshot.data.matricula),
          _textBuilder(Icons.email, snapshot.data.email),
        ]),
      ),
      SizedBox(
        width: 10,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<UserEntity>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container(
              margin: EdgeInsets.all(20),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 50,
                ),
                _createTop(snapshot),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 170,
                      child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {
                            if (await canLaunch(snapshot.data.linkedinUrl)) {
                              await launch(snapshot.data.linkedinUrl);
                            } else {
                              throw 'Could not launch your url';
                            }
                          },
                          child: Text("Acessar linkedin")),
                    ),
                    Container(
                        width: 170,
                        child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {},
                            child: Text("Acessar portfolio")))
                  ],
                ),
                Divider(
                  color: Colors.black,
                )
              ]));
        }
      },
    ));
  }
}
