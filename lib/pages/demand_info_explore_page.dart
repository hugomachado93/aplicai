import 'package:aplicai/entity/demanda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemandInfoExplorePage extends StatefulWidget {
  final Demanda demanda;

  DemandInfoExplorePage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _DemandInfoExplorePageState(demanda: this.demanda);
  }
}

class _DemandInfoExplorePageState extends State<DemandInfoExplorePage> {
  Demanda demanda;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String _demandPictureUrl;

  _DemandInfoExplorePageState({this.demanda});

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  Widget _createTop() {
    return Row(children: [
      Container(
        height: 120,
        width: 120,
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
          _textBuilder(Icons.folder, demanda.categories.toString()),
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

  Widget _bottomDescriptions(IconData icon, String title, String description) {
    return Row(
      children: [
        Icon(
          icon,
          size: 40,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title), Text(description)],
        )
      ],
    );
  }

  _loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var userData =
        await _db.collection("Users").doc(prefs.getString("userId")).get();
    return userData.data()['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            _createTop(),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  "Ver perfil do empreendimento",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Descrição:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(demanda.description),
                            Divider(
                              height: 50,
                              thickness: 1,
                            ),
                            _bottomDescriptions(Icons.calendar_today,
                                "Fim das inscrições", endDateFormated()),
                            _bottomDescriptions(Icons.watch_later, "Duração",
                                "Média, até 1 mês"),
                            _bottomDescriptions(Icons.group, "Grupo",
                                "${demanda.quantityParticipants} participantes"),
                            _bottomDescriptions(
                                Icons.folder, "Categorias", demanda.categories.toString()),
                            SizedBox(
                              height: 15,
                            ),
                            snapshot.data != "employer" && demanda.isFinished
                                ? Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        color: Colors.blueAccent,
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              "/demand-subscription",
                                              arguments: demanda);
                                        },
                                        child: Text(
                                          "Quero me increver!",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ])));
            }
          }),
    );
  }
}
