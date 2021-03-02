import 'package:aplicai/bloc/user_profile_bloc.dart';
import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  UserService userService = UserService();

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

  Widget _textListBuilder(IconData icon, List listText) {
    return Row(children: [
      Icon(icon),
      SizedBox(
        width: 10,
      ),
      Expanded(
          child: Row(
              children: listText
                  .map((e) => Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ))
                  .toList()))
    ]);
  }

  Widget _createTop(UserEntity userEntity) {
    return Row(children: [
      CachedNetworkImage(
        imageUrl: userEntity.urlImage,
        imageBuilder: (context, imageProvider) => Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black, blurRadius: 5)
              ],
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(userEntity.name),
          Divider(color: Colors.black),
          _textBuilder(Icons.school, userEntity.curso),
          _textBuilder(Icons.person, userEntity.matricula),
          _textBuilder(Icons.email, userEntity.email),
        ]),
      ),
      SizedBox(
        width: 10,
      ),
    ]);
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch your url';
    }
  }

  _finishedEmployerDemands(Empreendedor empreendedor) {
    return Expanded(
        child: ListView.builder(
            itemCount: empreendedor.demandas.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => {
                  Navigator.of(context).pushNamed("/demand-info-explore",
                      arguments: empreendedor.demandas[index])
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
                                    empreendedor.demandas[index].urlImage),
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
                                  empreendedor.demandas[index].name),
                              _textListBuilder(Icons.folder,
                                  empreendedor.demandas[index].categories),
                              _textBuilder(Icons.location_on,
                                  empreendedor.demandas[index].localization),
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

  _finishedStudentDemands(UserEntity userEntity) {
    return Expanded(
        child: ListView.builder(
            itemCount: userEntity.demandas.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => {
                  Navigator.of(context).pushNamed("/demand-info-explore",
                      arguments: userEntity.demandas[index])
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
                                    userEntity.demandas[index].urlImage),
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
                              _textBuilder(
                                  Icons.work, userEntity.demandas[index].name),
                              _textListBuilder(Icons.folder,
                                  userEntity.demandas[index].categories),
                              _textBuilder(Icons.location_on,
                                  userEntity.demandas[index].localization),
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
            color: Colors.black87,
          ),
          ListTile(
            tileColor: Colors.blue,
            title: Text('Settings'),
            onTap: () async {},
            onLongPress: () {},
          ),
          Container(
            height: 1,
            color: Colors.black87,
          ),
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

  _buildStudent(UserEntity userEntity) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Perfil do estudante"),
          leading: Container(),
        ),
        endDrawer: _drawer(),
        body: Container(
            margin: EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              _createTop(userEntity),
              SizedBox(
                height: 30,
              ),
              Text(
                "Descrição:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userEntity.description),
              SizedBox(
                height: 20,
              ),
              Text(
                "Skills:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: userEntity.categories
                      .map((skill) => Text("; "))
                      .toList()),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 170,
                    child: RaisedButton(
                        hoverColor: Colors.orange,
                        color: Colors.blue,
                        onPressed: () async {
                          _launchUrl(userEntity.linkedinUrl);
                        },
                        child: Text("Acessar linkedin")),
                  ),
                  Container(
                      width: 170,
                      child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {
                            _launchUrl(userEntity.portfolioUrl);
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
              userEntity.demandas.length != 0
                  ? _finishedStudentDemands(userEntity)
                  : Text("Não há demandas concluidas..."),
            ])));
  }

  _createEmployerTop(Empreendedor empreendedor) {
    return Row(children: [
      CachedNetworkImage(
        imageUrl: empreendedor.urlImage,
        imageBuilder: (context, imageProvider) => Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black, blurRadius: 5)
              ],
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(empreendedor.companyName),
          Divider(color: Colors.black),
          _textBuilder(Icons.school, empreendedor.cnpj),
          _textBuilder(Icons.person, empreendedor.razaoSocial),
          _textBuilder(Icons.email, empreendedor.email),
        ]),
      ),
      SizedBox(
        width: 10,
      ),
    ]);
  }

  _buildEmployer(Empreendedor empreendedor) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Perfil do empreendedor"),
          leading: Container(),
        ),
        endDrawer: _drawer(),
        body: Container(
            margin: EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              _createEmployerTop(empreendedor),
              SizedBox(
                height: 30,
              ),
              Text(
                "Descrição:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(empreendedor.description),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 170,
                    child: RaisedButton(
                        hoverColor: Colors.orange,
                        color: Colors.blue,
                        onPressed: () async {
                          _launchUrl(empreendedor.linkedinUrl);
                        },
                        child: Text("Acessar linkedin")),
                  ),
                  Container(
                      width: 170,
                      child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {
                            _launchUrl(empreendedor.portfolioUrl);
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
              empreendedor.demandas.length != 0
                  ? _finishedEmployerDemands(empreendedor)
                  : Text("Não há demandas concluidas..."),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc()..add(GetUserTypeProfile()),
      child: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is UserProfileInitial || state is UserProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserProfileStudent) {
            return _buildStudent(state.userEntity);
          } else if (state is UserProfileEmployer) {
            return _buildEmployer(state.empreendedor);
          }
        },
      ),
    );
  }
}
