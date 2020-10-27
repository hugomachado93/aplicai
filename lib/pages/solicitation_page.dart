import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SolicitationPage extends StatefulWidget {
  Demanda demanda;

  SolicitationPage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _SolicitationPageState(demanda: demanda);
  }
}

class _SolicitationPageState extends State<SolicitationPage> {
  Demanda demanda;
  UserService userService = UserService();

  _SolicitationPageState({this.demanda});

  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserEntity>>(
          future: userService.getAllUsersSolicitation(demanda),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Suas Solicitações",
                          style: TextStyle(fontSize: 30),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/placeholder.png"))),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person),
                                              Text(snapshot.data[index].name),
                                            ],
                                          ),
                                          Container(
                                            child: RaisedButton(
                                              onPressed: () {},
                                              color: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                  "Detalhes da solicitação"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ]),
                ),
              );
            }
          }),
    );
  }
}
