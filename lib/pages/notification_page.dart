import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  _getNotifications() async {
    final prefs = await SharedPreferences.getInstance(); 
    final data = await _db.collection("Users").doc(prefs.getString("userId")).collection("Notifications").get();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _getNotifications(),
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
                List<QueryDocumentSnapshot> notifications = snapshot.data.docs;
                return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      String notification = notifications[index].data()["notification"];
                      return Card(
                        child: Text(notification),
                      );                  
                    });
              }
            }));
  }
}
