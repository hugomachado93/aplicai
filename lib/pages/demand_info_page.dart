import 'package:aplicai/providers/demand_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DemandInfoPage extends StatefulWidget {
  final Demanda demanda;

  DemandInfoPage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _DemandInfoPageState(demanda: this.demanda);
  }
}

class _DemandInfoPageState extends State<DemandInfoPage> {
  Demanda demanda;
  _DemandInfoPageState({this.demanda});

  DemandProvider demandProvider = new DemandProvider();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  Widget _createTop() {
    return Row(children: [
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: NetworkImage(demanda.urlImage), fit: BoxFit.fill)),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Title"),
          Divider(color: Colors.black),
          _textBuilder(Icons.work, demanda.name),
          _textBuilder(Icons.folder, demanda.categories),
          _textBuilder(Icons.location_on, demanda.localization),
        ]),
      ),
      SizedBox(
        width: 10,
      ),
    ]);
  }

  String endDateFormated() {
    var dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(demanda.endDate.toDate());
  }

  int calculateDaysToEndDemand() {
    return demanda.endDate.toDate().difference(DateTime.now()).inDays;
  }

  int progressBarCalculation() {
    calculateDaysToEndDemand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _db
                .collection("Demands")
                .doc(demanda.parentId)
                .collection("DemandList")
                .doc(demanda.childId)
                .collection("Users")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        _createTop(),
                        SizedBox(
                          height: 30,
                        ),
                        calculateDaysToEndDemand() > 1
                            ? Text("Faltam ${calculateDaysToEndDemand()} dias")
                            : Text("É hoje"),
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 15,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: LinearProgressIndicator(
                              value: 0.05,
                            ),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "Entrega do projeto\n           ${endDateFormated()}"),
                              Icon(
                                Icons.calendar_today,
                                size: 50,
                              )
                            ]),
                        Divider(
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 170,
                              child: RaisedButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        "/solicitation",
                                        arguments: demanda);
                                  },
                                  child: Text("Ver solicitações")),
                            ),
                            Container(
                                width: 170,
                                child: RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () {},
                                    child: Text("Concluir demanda")))
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Text("Participants"),
                        Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data.docs[index]
                                                .data()['urlImage']),
                                            fit: BoxFit.fill)),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 30,
                                  );
                                },
                              ),
                            )),
                        Text("Contatos"),
                        Row(children: [
                          Icon(Icons.email),
                          Text("${demanda.name}: ${demanda.name}"),
                          ]),
                        Expanded(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Icon(Icons.email),
                                      Text("${snapshot.data.docs[index].data()['name']}: ${snapshot.data.docs[index].data()['email']}"),
                                    ],
                                  );
                                }))
                      ],
                    ));
              }
            }));
  }
}
