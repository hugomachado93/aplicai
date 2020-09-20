import 'package:flutter/material.dart';

class EmAndamentoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmAndamentoPageState();
  }
}

class _EmAndamentoPageState extends State<EmAndamentoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          width: 150  ,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/nova-demanda');
              },
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.add, size: 15,),
                Text("Nova demanda"),
              ])),
        ),
        body: Container(
          child: Center(
            child: Text("Teste"),
          ),
        ));
  }
}
