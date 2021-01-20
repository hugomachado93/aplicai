import 'dart:ui';
import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class SignupPageEmpreendedor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageEmpreendedorState();
  }
}

class _SignupPageEmpreendedorState extends State<SignupPageEmpreendedor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _companyName;
  String _email;
  String _cnpj;
  String _razaoSocial;
  String _desciption;
  String _linkedinUrl;
  String _portfolioUrl;
  File _image;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  SharedPreferences prefs;

  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Widget _buildCompanyNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Nome da empresa"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Nome invalido";
        }
      },
      onSaved: (value) => {_companyName = value},
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

  Widget _buildCnpjField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "CNPJ"),
      validator: (String value) {
        if (value.isEmpty) {
          return "CNPJ invalido";
        }
      },
      onSaved: (value) => {_cnpj = value},
    );
  }

  Widget _buildRazaoSocialField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Razão Social"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Curso invalido";
        }
      },
      onSaved: (value) => {_razaoSocial = value},
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Descrição do empreendimento"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Descrição invalida";
        }
      },
      onSaved: (value) => {_desciption = value},
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

  _saveUserData() async {
    try {
      prefs = await SharedPreferences.getInstance();
      var user = Empreendedor(_companyName, _email, _cnpj, _razaoSocial,
          _desciption, _linkedinUrl, _portfolioUrl, true);
      _db.collection("Users").doc(prefs.getString("userId")).set(user.toJson());

      Navigator.of(context)..pushNamed("/navigation");
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
                    "Empreendimento",
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
                      _buildCompanyNameField(),
                      _buildEmailField(),
                      _buildCnpjField(),
                      _buildRazaoSocialField(),
                      _buildDescriptionField(),
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
