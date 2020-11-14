import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/enum/userTypeEnum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmAndamentoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmAndamentoPageState();
  }
}

class _EmAndamentoPageState extends State<EmAndamentoPage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> _getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    var userData = await _db.collection("Users").doc(userId).get();
    return userData.data()['type'];
  }

  Future<QuerySnapshot> _getUserDemands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    final userData = await _db.collection("Users").doc(userId).get();
    final type = userData.data()['type'];
    if(type == UserTypeEnum.student.toString()){
      return _db.collection("Users").doc(userId).collection("Demands").get();
    } else {
      return _db.collection("Demands").doc(userId).collection("DemandList").get();
    }
  }

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  Widget _createCards(QueryDocumentSnapshot demand) {
    Demanda demanda = Demanda.fromJson(demand.data());
    demanda.parentId = demand.reference.parent.parent.id;
    demanda.childId = demand.id;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed('/demand-info', arguments: demanda),
        child: Container(
            child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(demand.data()['urlImage']),
                      fit: BoxFit.fill)),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title"),
                    Divider(
                      height: 5,
                      thickness: 1,
                    ),
                    _textBuilder(Icons.work, demanda.name),
                    _textBuilder(Icons.folder, demanda.categories),
                    _textBuilder(Icons.location_on, demanda.localization),
                  ]),
            ),
            SizedBox(
              width: 10,
            )
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _getUserType() != 'employer'
            ? Container(
                width: 150,
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/nova-demanda');
                    },
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 15,
                          ),
                          Text("Nova demanda"),
                        ])),
              )
            : null,
        body: FutureBuilder<QuerySnapshot>(
            future: _getUserDemands(),
            builder: (context, querySnapshot) {
              if (querySnapshot.hasError) {
                return Text("ERROR");
              }
              if (querySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<QueryDocumentSnapshot> demandList =
                    querySnapshot.data.docs;

                return Container(
                  child: Center(
                      child: Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Row(children: [
                          SizedBox(width: 15),
                          Text("Explorar", style: TextStyle(fontSize: 30))
                        ]),
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: demandList.length,
                              itemBuilder: (context, index) {
                                return _createCards(demandList[index]);
                              })),
                    ],
                  )),
                );
              }
            }));
  }
}
