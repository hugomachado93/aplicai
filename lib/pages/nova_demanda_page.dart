import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class NovaDemandaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NovaDemandaPageState();
  }
}

class _NovaDemandaPageState extends State<NovaDemandaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;
  String _description;
  String _categories;
  String _quantityParticipants;
  String _localization;
  DateTime _date = DateTime.now();
  TextEditingController endDateCtrl = TextEditingController();
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

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Nome"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Nome invalido";
        }
      },
      onSaved: (value) => {_name = value},
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Descrição"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Descrição invalida";
        }
      },
      onSaved: (value) => {_description = value},
    );
  }

  Widget _buildCategoriesField() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: "Categorias (separadas por virgula)"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Categoria inválida";
        }
      },
      onSaved: (value) => {_categories = value},
    );
  }

  Widget _buildQuantityParticipantsField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Quantidade de participantes"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Quantiade inválida";
        }
      },
      onSaved: (value) => {_quantityParticipants = value},
    );
  }

  Widget _buildLocalizationsField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Localização"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Localização invalida";
        }
      },
      onSaved: (value) => {_localization = value},
    );
  }

  Widget _buildDemandImageField() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        InkWell(onTap: () => {_getImage()}, child: Text("Selecionar imagem")),
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

  Widget _buildEndDateField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Data do fim das incrições", hintText: "dd/MM/yyyy"),
      controller: endDateCtrl,
      onTap: () async {
        var myFormat = DateFormat('dd/MM/yyyy');
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime date = await _selectDate(context);
        endDateCtrl.text = myFormat.format(date).toString();
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (datePicked != null && datePicked != _date) {
      setState(() {
        _date = datePicked;
      });
    }
    return datePicked;
  }

  _saveDemandData() async {
    try {
      prefs = await SharedPreferences.getInstance();

      _db.collection("Demands").doc(prefs.getString("userId")).set({
        "name": _name,
        "description": _description,
        "categories": _categories,
        "quantityParticipants": _quantityParticipants,
        "localization": _localization,
        "endDate": _date
      });

      Navigator.of(context)..pushNamed("/");
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
              margin: EdgeInsets.all(24),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      _buildNameField(),
                      _buildDescriptionField(),
                      _buildCategoriesField(),
                      _buildQuantityParticipantsField(),
                      _buildLocalizationsField(),
                      _buildEndDateField(context),
                      _buildDemandImageField(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 400,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("Criar demanda"),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            _saveDemandData();
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
