import 'package:aplicai/entity/demanda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemandSubscriptionPage extends StatefulWidget {
  Demanda demanda;

  DemandSubscriptionPage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _DemandSubscriptionPageState(demanda: demanda);
  }
}

class _DemandSubscriptionPageState extends State<DemandSubscriptionPage> {
  Demanda demanda;
  String _motivationText;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  _DemandSubscriptionPageState({this.demanda});

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  Widget _createTop() {
    return Row(children: [
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/placeholder.png"),
                fit: BoxFit.fill)),
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

  _loadUserType() async {
    var prefs = await SharedPreferences.getInstance();
    var userData =
        await _db.collection("Users").doc(prefs.getString("userId")).get();
    return userData.data()['type'];
  }

  _createSolicitation() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    var prefs = await SharedPreferences.getInstance();
    _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .collection("Solicitation")
        .doc(prefs.getString("userId"))
        .set({'motivationText': _motivationText});

    Navigator.of(context)
        .pushNamed("/finished-subscription", arguments: demanda);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder(
          future: _loadUserType(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        _createTop(),
                        Divider(
                          height: 50,
                          thickness: 1,
                        ),
                        Text(
                          "Interessado no projeto?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("O que te faz querer ingressar nesse projeto?"),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            "Conte um pouco sobre suas ambições para seu parceiro!"),
                        SizedBox(
                          height: 15,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            maxLength: 400,
                            onSaved: (value) => _motivationText = value,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Não pode ser vazio!";
                              }
                            },
                            buildCounter: (
                              BuildContext context, {
                              int currentLength,
                              int maxLength,
                              bool isFocused,
                            }) =>
                                Text("$currentLength/$maxLength"),
                            maxLines: 10,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              onPressed: _createSolicitation,
                              child: Text(
                                "Quero me increver!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]));
            }
          }),
    ));
  }
}
