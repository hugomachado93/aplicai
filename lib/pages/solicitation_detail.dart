import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/solicitation.dart';
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

    final _data = await _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .get();

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
                                          image: AssetImage(
                                              "assets/images/placeholder.png"))),
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
                              Container(
                                width: 180,
                                child: RaisedButton(
                                    child: Text("Aceitar"),
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () async {
                                      List<String> reference = [];
                                      reference.add(
                                          "Users/${snapshot.data.demanda.solicitationId}");
                                      final data = await _db
                                          .collection("Demands")
                                          .doc(demanda.parentId)
                                          .collection("DemandList")
                                          .doc(demanda.childId)
                                          .set({'users': reference});
                                    }),
                              ),
                              Container(
                                width: 180,
                                child: RaisedButton(
                                    child: Text("Recusar"),
                                    color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {}),
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
