import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExplorePageState();
  }
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedIndex = 0;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        body: Container(
          child: Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [SizedBox(width: 15), Text("Explorar", style: TextStyle(fontSize: 30))]),
                  ),
                  Expanded(
            child: StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("Users").snapshots(),
                    builder: (context, querySnapshot) {
                      if (querySnapshot.hasError) {
                        return Text("ERROR");
                      }
                      if (querySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        final userList = querySnapshot.data.docs;

                        return ListView.builder(
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                margin: EdgeInsets.all(15),
                                child: Container(
                                    child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/placeholder.png"),
                                              fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Title"),
                                            Divider(
                                              height: 5,
                                              thickness: 1,
                                            ),
                                            _textBuilder(Icons.work, "Hey"),
                                            _textBuilder(Icons.folder, "Hey"),
                                            _textBuilder(Icons.location_on, "Hey"),
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                )),
                              );
                            });
                      }
                    }),
          ),
                ],
              )),
        ));
  }
}
