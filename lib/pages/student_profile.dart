import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentProfile {
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

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch your url';
    }
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

  Widget _drawer(BuildContext context, AuthService authService) {
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

  List<Container> _finishedStudentDemands(
      UserEntity userEntity, BuildContext context) {
    return userEntity.demandas.map((stu) {
      return Container(
        child: InkWell(
          onTap: () => {
            Navigator.of(context)
                .pushNamed("/demand-info-explore", arguments: stu)
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
                          image: NetworkImage(stu.urlImage), fit: BoxFit.fill)),
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
                        _textBuilder(Icons.work, stu.name),
                        _textListBuilder(Icons.folder, stu.categories),
                        _textBuilder(Icons.location_on, stu.localization),
                      ]),
                ),
                SizedBox(
                  width: 10,
                ),
              ]),
            ),
          ),
        ),
      );
    }).toList();
  }

  buildStudent(
      UserEntity userEntity, BuildContext context, AuthService authService) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Perfil do estudante"),
          leading: Container(),
        ),
        endDrawer: _drawer(context, authService),
        body: SingleChildScrollView(
          child: Container(
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
                    userEntity.linkedinUrl.isNotEmpty
                        ? Container(
                            width: 170,
                            child: RaisedButton(
                                hoverColor: Colors.orange,
                                color: Colors.blue,
                                onPressed: () async {
                                  _launchUrl(userEntity.linkedinUrl);
                                },
                                child: Text("Acessar linkedin")),
                          )
                        : Container(),
                    userEntity.portfolioUrl.isNotEmpty
                        ? Container(
                            width: 170,
                            child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  _launchUrl(userEntity.portfolioUrl);
                                },
                                child: Text("Acessar portfolio")))
                        : Container()
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
                userEntity.demandas.length == 0
                    ? Text("Não há demandas concluidas...")
                    : Container(),
                ..._finishedStudentDemands(userEntity, context)
              ])),
        ));
  }
}
