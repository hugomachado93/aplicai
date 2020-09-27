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
    return _DemandSubscriptionPageState();
  }
}

class _DemandSubscriptionPageState extends State<DemandSubscriptionPage> {
  Demanda demanda;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  _DemandSubscriptionPageState({this.demanda});

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  // solicitation() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   _db
  //       .collection("Demands")
  //       .doc("GynLolnoRlc418C9fCEbK6BrXKA2")
  //       .collection("DemandList")
  //       .doc("crCxLs9cDcywzq0ktIcq")
  //       .collection("Solicitation")
  //       .doc(prefs.getString("userId"))
  //       .set({'motivationText': 'text here'});
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder(
          future: _loadUserType(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                      ]));
            }
          }),
    ));
  }
}
