import 'package:aplicai/bloc/notification_bloc.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/notifications/notification_invoker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var userEntity = Provider.of<UserEntity>(context);

    return Scaffold(
        body: BlocProvider(
            create: (context) => NotificationBloc()
              ..add(GetNotifications(userEntity: userEntity)),
            child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
              if (state is NotificationInitial) {
                return CustomCircularProgressIndicator();
              } else if (state is NotificationLoading) {
                return Center(
                  child: CustomCircularProgressIndicator(),
                );
              } else if (state is NotificationLoaded) {
                List<QueryDocumentSnapshot> notifications =
                    state.notifySnapshot;
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Notificações",
                        style: TextStyle(fontSize: 30, color: Colors.black)),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    leading: null,
                    elevation: 0,
                  ),
                  body: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        notifications.length == 0
                            ? Text("Não há notificações")
                            : Container(),
                        ListView.builder(
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
                                  key: Key(
                                      "${DateTime.now().toUtc().millisecondsSinceEpoch}"),
                                  background: Container(
                                    child: Icon(Icons.delete),
                                  ),
                                  child: NotificationInvoker()
                                      .invokeNotificationByType(notify));
                            }),
                      ],
                    ),
                  ),
                );
              }
            })));
  }
}
