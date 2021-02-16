import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

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
  String _urlImage;
  DateTime _date = DateTime.now();
  TextEditingController endDateCtrl = TextEditingController();
  File _image;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  SharedPreferences prefs;

  bool _isLoadingImage = false;

  final picker = ImagePicker();

  Future _getImage() async {
    setState(() {
      _isLoadingImage = true;      
    });
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    _image = File(pickedFile.path);

    var prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    Reference reference = _storage.ref().child(
        "/demands/$userId${DateTime.now().toUtc().millisecondsSinceEpoch}");
    UploadTask uploadTask = reference.putFile(_image);

    TaskSnapshot storageTaskSnapshot = await uploadTask;
    _urlImage = await storageTaskSnapshot.ref.getDownloadURL();
    setState(() {
      _isLoadingImage = false;
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
      maxLength: 400,
      onSaved: (value) => _description = value,
      validator: (String value) {
        if (value.isEmpty) {
          return "Não pode ser vazio!";
        }
      },
      buildCounter: (
        BuildContext context, {
        int currentLength,
        int maxLength,
        bool isFocused,
      }) =>
          Text("$currentLength/$maxLength"),
      maxLines: 10,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: "Descrição",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
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
    return InkWell(
      onTap: () => {_getImage()},
      child: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("Selecionar imagem"),
          _urlImage == null
              ? !_isLoadingImage ? Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.all(15),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(Icons.photo),
                  ),
                ) : Container(
                  margin: EdgeInsets.all(15),
                  child: CircularProgressIndicator())
              : Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: FileImage(_image), fit: BoxFit.fill)))
        ]),
      ),
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

      if (_isLoadingImage) {
      } else {
        _db
            .collection("Demands")
            .doc(prefs.getString("userId"))
            .collection("DemandList")
            .doc()
            .set({
          "name": _name,
          "description": _description,
          "categories": _categories,
          "quantityParticipants": _quantityParticipants,
          "localization": _localization,
          "endDate": _date,
          "startDate": DateTime.now(),
          "urlImage": _urlImage,
          "isFinished": false,
        });

        Navigator.of(context).pushNamed("/navigation");
      }
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
                      SizedBox(height: 20,),
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
