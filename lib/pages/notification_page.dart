import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/notifications/notification_invoker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplicai/service/user_service.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    var userEntity = Provider.of<UserEntity>(context);
      return Scaffold(
          body: StreamBuilder(
              stream: userService.getUserNotifications(userEntity),
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
                } else if (snapshot.hasData){
                  List<QueryDocumentSnapshot> notifications =
                      snapshot.data.docs;
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Row(children: [
                            SizedBox(width: 15),
                            Text("Notificações", style: TextStyle(fontSize: 30))
                          ]),
                        ),
                        ListView.builder(
                            itemExtent: 100,
                            shrinkWrap: true,
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              Notify notify =
                                  Notify.fromJson(notifications[index].data());
                              return Dismissible(
                                onDismissed: (direction) {
                                  _db
                                      .collection("Users")
                                      .doc(userEntity.userId)
                                      .collection("Notifications")
                                      .doc(notifications[index].id)
                                      .delete();
                                },
                                key: Key(notify.imageUrl),
                                background: Container(
                                  child: Icon(Icons.delete),
                                ),
                                child: NotificationInvoker().invokeNotificationByType(notify));
                            }),
                      ],
                    ),
                  );
                }
              }));
    
  }
}
