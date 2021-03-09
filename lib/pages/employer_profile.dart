import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployerProfile {
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

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch your url';
    }
  }

  List<Container> _finishedEmployerDemands(
      Empreendedor empreendedor, BuildContext context) {
    return empreendedor.demandas.map((emp) {
      return Container(
        child: InkWell(
          onTap: () => {
            Navigator.of(context)
                .pushNamed("/employer-demand-info", arguments: emp)
          },
          child: Container(
            height: 120,
            child: Card(
              color: Colors.white,
              shadowColor: Colors.grey,
              elevation: 15,
              child: Row(children: [
                SizedBox(
                  width: 0,
                ),
                CachedNetworkImage(
                  imageUrl: emp.urlImage,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill)),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
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
                        _textBuilder(Icons.work, emp.name),
                        _textListBuilder(Icons.folder, emp.categories),
                        _textBuilder(Icons.location_on, emp.localization),
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

  Widget _drawer(BuildContext context, AuthService authService,
      Empreendedor empreendedor) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 0, 100, 255),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: empreendedor.urlImage,
                    imageBuilder: (context, imageProvider) => ListTile(
                      title: Text(empreendedor.companyName),
                      subtitle: Text(empreendedor.email),
                      leading: CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),
                    placeholder: (context, url) =>
                        CustomCircularProgressIndicator(),
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              title: Text('Minha Conta'),
              onTap: () async {},
              onLongPress: () {},
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () async {},
              onLongPress: () {},
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () async {
                await authService.logoutUser();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/", (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
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

  buildEmployerInfo(Empreendedor empreendedor, BuildContext context,
      AuthService authService) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: 30,
              ),
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
                  empreendedor.linkedinUrl.isNotEmpty
                      ? Container(
                          width: 170,
                          child: RaisedButton(
                              hoverColor: Colors.orange,
                              color: Colors.blue,
                              onPressed: () async {
                                _launchUrl(empreendedor.linkedinUrl);
                              },
                              child: Text("Acessar linkedin")),
                        )
                      : Container(),
                  empreendedor.portfolioUrl.isNotEmpty
                      ? Container(
                          width: 170,
                          child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () async {
                                _launchUrl(empreendedor.portfolioUrl);
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
              empreendedor.demandas.length == 0
                  ? Text("Não há demandas concluidas...")
                  : Container(),
              ..._finishedEmployerDemands(empreendedor, context)
            ])),
      ),
    );
  }

  buildEmployer(Empreendedor empreendedor, BuildContext context,
      AuthService authService) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Perfil do empreendedor"),
          leading: Container(),
        ),
        endDrawer: _drawer(context, authService, empreendedor),
        body: SingleChildScrollView(
          child: Container(
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
                    empreendedor.linkedinUrl.isNotEmpty
                        ? Container(
                            width: 170,
                            child: RaisedButton(
                                hoverColor: Colors.orange,
                                color: Colors.blue,
                                onPressed: () async {
                                  _launchUrl(empreendedor.linkedinUrl);
                                },
                                child: Text("Acessar linkedin")),
                          )
                        : Container(),
                    empreendedor.portfolioUrl.isNotEmpty
                        ? Container(
                            width: 170,
                            child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  _launchUrl(empreendedor.portfolioUrl);
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
                empreendedor.demandas.length == 0
                    ? Text("Não há demandas concluidas...")
                    : Container(),
                ..._finishedEmployerDemands(empreendedor, context)
              ])),
        ));
  }
}
