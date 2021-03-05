import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/solicitation.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  _updateParticipantsOfDemand(AsyncSnapshot<Solicitation> snapshot) async {
    final userData =
        await _db.collection("Users").doc(demanda.solicitationId).get();

    await _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .collection("Users")
        .doc(demanda.solicitationId)
        .set(userData.data());

    await _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .collection("Solicitation")
        .doc(demanda.solicitationId)
        .delete();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final demandData = await _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .get();

    await _db
        .collection("Users")
        .doc(prefs.getString("userId"))
        .collection("Demands")
        .doc(demanda.childId)
        .set(demandData.data());

    await _db
        .collection("Users")
        .doc(demanda.solicitationId)
        .collection("Demands")
        .doc(demanda.childId)
        .set(demandData.data());

    await _db
        .collection("Users")
        .doc(demanda.solicitationId)
        .collection("Notifications")
        .doc()
        .set({
      "name": demanda.name,
      "imageUrl": demanda.urlImage,
      "notification": "Sua proposta foi aceita",
      "type": "solicitation"
    });
  }

  Future<Solicitation> _getUserSolicitation() async {
    final solicitation = await _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .collection("Solicitation")
        .doc(demanda.solicitationId)
        .get();

    String data = solicitation.data()['motivationText'];

    final _data =
        await _db.collection("Users").doc(demanda.solicitationId).get();

    UserEntity userEntity = UserEntity.fromJson(_data.data());

    Solicitation solicitationData = new Solicitation(
        userEntity: userEntity, demanda: demanda, motivationText: data);

    return solicitationData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Solicitation>(
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
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data.userEntity.urlImage),
                                          fit: BoxFit.fill)),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person),
                                          Expanded(
                                              child: Text(snapshot
                                                  .data.userEntity.name)),
                                        ],
                                      ),
                                      Container(
                                        child: RaisedButton(
                                          onPressed: () {},
                                          color: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text("Ver perfil"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(snapshot.data.motivationText),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 180,
                                  child: RaisedButton(
                                      child: Text("Aceitar"),
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      onPressed: () async {
                                        await _updateParticipantsOfDemand(
                                            snapshot);
                                        Navigator.of(context).pop();
                                      }),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Expanded(
                                child: Container(
                                  width: 180,
                                  child: RaisedButton(
                                      child: Text("Recusar"),
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      onPressed: () {}),
                                ),
                              )
                            ],
                          )
                        ]),
                  ),
                );
              }
            }));
  }
}
