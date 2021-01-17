import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getUserNotifications(UserEntity userEntity) {
    return _db
        .collection("Users")
        .doc(userEntity.userId)
        .collection("Notifications")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var userEntity = Provider.of<UserEntity>(context);
    if (userEntity != null) {
      return Scaffold(
          body: StreamBuilder(
              stream: _getUserNotifications(userEntity),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<QueryDocumentSnapshot> notifications =
                      snapshot.data.docs;
                  return ListView.builder(
                      itemExtent: 100,
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        Notify notify =
                            Notify.fromJson(notifications[index].data());
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.all(15),
                            child: Container(
                                height: 200,
                                child: Row(children: [
                                  Container(
                                      height: 120,
                                      width: 120,
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  notify.imageUrl)))),
                                  Text(notify.name),
                                  Text(notify.notification)
                                ])));
                      });
                }
              }));
    }
  }
}
