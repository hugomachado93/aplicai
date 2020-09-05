import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;
  String _email;
  String _senha;
  String _curso;
  String _matricula;
  String _linkedinUrl;
  String _portfolioUrl;
  File _image;

  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Nome Completo"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Nome invalido";
        }
      },
      onSaved: (value) => {_name = value},
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Nome invalido";
        }
      },
      onSaved: (value) => {_email = value},
    );
  }

  Widget _buildCpfField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Senha"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Cpf invalido";
        }
      },
      onSaved: (value) => {_senha = value},
    );
  }

  Widget _buildCursoField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Curso"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Curso invalido";
        }
      },
      onSaved: (value) => {_curso = value},
    );
  }

  Widget _buildMatriculaField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Matricula"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Matricula invalida";
        }
      },
      onSaved: (value) => {_matricula = value},
    );
  }

  Widget _buildLinkedinLinkField() {
    return TextFormField(
      style: TextStyle(color: Colors.amber),
      obscureText: true,
      decoration: InputDecoration(labelText: "Url Linkedin (Opcional)"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Link invalido";
        }
      },
      onSaved: (value) => {_linkedinUrl = value},
    );
  }

  Widget _buildPortfolioLinkField() {
    return TextFormField(
      style: TextStyle(color: Colors.amber),
      obscureText: true,
      decoration: InputDecoration(labelText: "Url Portfolio (Opcional)"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Link invalido";
        }
      },
      onSaved: (value) => {_portfolioUrl = value},
    );
  }

  Widget _buildPerfilImageField() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        InkWell(
            onTap: () => {_getImage()},
            child: Text("Selecionar imagem de perfil")),
        Container(
          color: Colors.transparent,
        ),
        _image == null
            ? Container(
                height: 100,
                width: 100,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(Icons.photo),
                ),
              )
            : Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(_image), fit: BoxFit.fill)))
      ]),
    );
  }

  _saveUserData() {
    try {
      Navigator.of(context)..pushNamed("/explorar");
    } catch (ex) {
      print("Failed to create user $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Aluno",
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              margin: EdgeInsets.all(24),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildNameField(),
                      _buildEmailField(),
                      _buildCpfField(),
                      _buildCursoField(),
                      _buildMatriculaField(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildPerfilImageField(),
                      _buildLinkedinLinkField(),
                      _buildPortfolioLinkField(),
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        width: 400,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("Criar conta"),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            _saveUserData();
                          },
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
