import 'package:aplicai/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:aplicai/service/auth_service.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserProfilePageState();
  }
}

class _UserProfilePageState extends State<UserProfilePage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  AuthService authService = AuthService();

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [
      Icon(icon),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
        ),
      )
    ]);
  }

  Widget _createTop(AsyncSnapshot<UserEntity> snapshot) {
    return Row(children: [
      Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.black, blurRadius: 5)
            ],
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: NetworkImage(snapshot.data.urlImage), fit: BoxFit.fill)),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(snapshot.data.name),
          Divider(color: Colors.black),
          _textBuilder(Icons.school, snapshot.data.curso),
          _textBuilder(Icons.date_range, snapshot.data.matricula),
          _textBuilder(Icons.email, snapshot.data.email),
        ]),
      ),
      SizedBox(
        width: 10,
      ),
    ]);
  }

  _launchUrl(AsyncSnapshot<UserEntity> snapshot) async {
    if (await canLaunch(snapshot.data.linkedinUrl)) {
      await launch(snapshot.data.linkedinUrl);
    } else {
      throw 'Could not launch your url';
    }
  }

  _finishedDemands(AsyncSnapshot<UserEntity> snapshot) {
    return Expanded(
        child: ListView.builder(
            itemCount: snapshot.data.demandas.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => {
                  Navigator.of(context).pushNamed("/demand-info-explore", arguments: snapshot.data.demandas[index])
                },
                child: Container(
                  height: 120,
                  child: Card(
                    color: Colors.blueGrey,
                    shadowColor: Colors.blueGrey,
                    elevation: 10,
                    child: Row(children: [
                      SizedBox(
                        width: 0,
                      ),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.data.demandas[index].urlImage),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text("Title"),
                              Divider(color: Colors.black),
                              _textBuilder(Icons.work,
                                  snapshot.data.demandas[index].name),
                              _textBuilder(Icons.folder,
                                  snapshot.data.demandas[index].categories),
                              _textBuilder(Icons.location_on,
                                  snapshot.data.demandas[index].localization),
                            ]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ]),
                  ),
                ),
              );
            }));
  }

  Widget _drawer() {
    return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text('Drawer Header'),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
              Container(
                height: 10,
                color: Colors.black87,),
              ListTile(
                tileColor: Colors.blue,
                title: Text('Settings'),
                onTap: () async {
                },
              onLongPress: (){},
              ),
                            Container(
                height: 1,
                color: Colors.black87,),
              ListTile(
                title: Text('Logout'),
                tileColor: Colors.blue,
                onTap: () async {
                   await authService.logoutUser();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "/", (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Perfil do estudante"),
          leading: Container(),
        ),
        endDrawer: _drawer(),
        body: FutureBuilder<UserEntity>(
          future: userService.getUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _createTop(snapshot),
                        SizedBox(
                          height: 30,
                        ),
                        Text("Descrição:", style: TextStyle(fontWeight: FontWeight.bold),),
                        InkWell(child: Text("Colocar uma descrição..."), 
                        onTap: () {
                          
                        },),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 170,
                              child: RaisedButton(
                                hoverColor: Colors.orange,
                                  color: Colors.blue,
                                  onPressed: () async {
                                    _launchUrl(snapshot);
                                  },
                                  child: Text("Acessar linkedin")),
                            ),
                            Container(
                                width: 170,
                                child: RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () async {
                                      _launchUrl(snapshot);
                                    },
                                    child: Text("Acessar portfolio")))
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Text(
                          "Demandas concluidas",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        snapshot.data.demandas.length != 0
                            ? _finishedDemands(snapshot)
                            : Text("Não há demandas concluidas..."),
                      ]));
            }
          },
        ));
  }
}
