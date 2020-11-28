import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/demand_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExplorePageState();
  }
}

class _ExplorePageState extends State<ExplorePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _db.collectionGroup("DemandList").snapshots(),
            builder: (context, querySnapshot) {
              if (querySnapshot.hasError) {
                return Text("ERROR");
              } else if (querySnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                final demandList = querySnapshot.data.docs;
                return Container(
                    child: Center(
                        child: Column(children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      SizedBox(width: 15),
                      Text("Explorar", style: TextStyle(fontSize: 30))
                    ]),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: demandList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Demanda demanda =
                                    Demanda.fromJson(demandList[index].data());
                                demanda.parentId = demandList[index]
                                    .reference
                                    .parent
                                    .parent
                                    .id;
                                demanda.childId = demandList[index].id;
                                Navigator.of(context).pushNamed(
                                    "/demand-info-explore",
                                    arguments: demanda);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                margin: EdgeInsets.all(15),
                                child: Container(
                                    child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  demandList[index]
                                                      .data()['urlImage']),
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
                                            _textBuilder(
                                                Icons.work,
                                                demandList[index]
                                                    .data()["name"]),
                                            _textBuilder(
                                                Icons.folder,
                                                demandList[index]
                                                    .data()["categories"]),
                                            _textBuilder(
                                                Icons.location_on,
                                                demandList[index]
                                                    .data()["localization"]),
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                )),
                              ),
                            );
                          }))
                ])));
              }
            }));
  }
}
