import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SolicitationDetailPage extends StatefulWidget {
  Demanda demanda;
  SolicitationDetailPage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _SolicitationDetailPageState(demanda: demanda);
  }
}

class _SolicitationDetailPageState extends State<SolicitationDetailPage> {
  Demanda demanda;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  UserService userService = UserService();

  _SolicitationDetailPageState({this.demanda});

  Future<String> _getUserSolicitation() async {
    final solicitation = await _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .collection("Solicitation")
        .doc(demanda.solicitationId)
        .get();
    String data = solicitation.data()['motivationText'];
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<String>(
            future: _getUserSolicitation(),
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
                  child: Text(snapshot.data),
                );
              }
            }));
  }
}
