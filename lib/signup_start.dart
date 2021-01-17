import 'dart:ui';

import 'package:aplicai/enum/userTypeEnum.dart';
import 'package:flutter/material.dart';

class SignupStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Text(
                    'Olá!',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text('Como gostaria de se cadastrar?')
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/pre-signup-pages',
                          arguments: UserTypeEnum.student);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/lapis.png"),
                                  fit: BoxFit.fill)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text("Aluno"),
                        Text("Procurando mais pratica na"),
                        Text("sua formação.")
                      ],
                    )),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/pre-signup-pages',
                          arguments: UserTypeEnum.employer);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/maleta.png"),
                                  fit: BoxFit.fill)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text("Empreendimento"),
                        Text("Projetos Sociais,"),
                        Text("Microempreendimentos,"),
                        Text("Empresas"),
                        Text("etc.")
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
