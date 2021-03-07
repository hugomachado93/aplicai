import 'package:aplicai/entity/demanda.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SubscriptionFinishedPage extends StatefulWidget {
  Demanda demanda;

  SubscriptionFinishedPage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _SubscriptionFinishedPageState(demanda: demanda);
  }
}

class _SubscriptionFinishedPageState extends State<SubscriptionFinishedPage> {
  Demanda demanda;

  _SubscriptionFinishedPageState({this.demanda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Sucesso!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text("Sua solicitação foi enviada."),
            SizedBox(
              height: 110,
            ),
            CachedNetworkImage(
              imageUrl: demanda.urlImage,
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
            Text(
              demanda.name,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Categorias:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: demanda.categories
                  .map((category) => Text("$category "))
                  .toList(),
            ),
            SizedBox(
              height: 180,
            ),
            Text("Você pode acompanhar o status da solicitação na aba de"),
            Text("projetos em andamentos"),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.of(context).pushNamed("/navigation");
                },
                child: Text(
                  "Voltar a navegação!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ])),
    ));
  }
}
