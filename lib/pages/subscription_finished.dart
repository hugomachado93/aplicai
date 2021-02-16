import 'package:aplicai/entity/demanda.dart';
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
        body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            child: Column(children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Sucesso!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text("Sua solicitação foi enviado."),
              SizedBox(
                height: 150,
              ),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(demanda.urlImage),
                        fit: BoxFit.fill)),
              ),
              Text(demanda.name),
              Row(
                children: demanda.categories.map((e) => Text(e)).toList(),
              ),
              SizedBox(
                height: 200,
              ),
              Text("Você pode acompanhar o status da solicitação na aba de"),
              Text("projetos em andamentos"),
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
            ])));
  }
}
