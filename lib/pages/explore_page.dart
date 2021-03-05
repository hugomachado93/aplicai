import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/demand_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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

  Widget _textListBuilder(IconData icon, List listText) {
    return Row(children: [
      Icon(icon),
      SizedBox(
        width: 10,
      ),
      Expanded(
          child: Row(
              children: listText
                  .map((e) => Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ))
                  .toList()))
    ]);
  }

  Stream<QuerySnapshot> _getDemandsFilteredForUser() {
    return _db
        .collectionGroup("DemandList")
        .where('isFinished', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _getDemandsFilteredForUser(),
            builder: (context, querySnapshot) {
              if (querySnapshot.hasError) {
                return Center(child: Text(querySnapshot.error.toString()));
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
                            Demanda demanda =
                                Demanda.fromJson(demandList[index].data());
                            return InkWell(
                              onTap: () {
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
                                color: Colors.white60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                margin: EdgeInsets.all(15),
                                child: Container(
                                    child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          demandList[index].data()['urlImage'],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill)),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
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
                                                Icons.work, demanda.name),
                                            _textListBuilder(Icons.folder,
                                                demanda.categories),
                                            _textBuilder(Icons.location_on,
                                                demanda.localization),
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
