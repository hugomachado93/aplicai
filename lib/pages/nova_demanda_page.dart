import 'dart:ui';
import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/service/demand_service.dart';
import 'package:flutter_tags/flutter_tags.dart';
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
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  String _name;
  String _description;
  String _quantityParticipants;
  String _localization;
  String _urlImage;
  List _items = [];
  List<String> _itemsTitle = [];
  DateTime _date = DateTime.now();
  TextEditingController endDateCtrl = TextEditingController();
  File _image;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  SharedPreferences prefs;
  final demandService = DemandService();

  bool _isLoadingImage = false;

  final picker = ImagePicker();

  Future _getImage() async {
    try {
      setState(() {
        _isLoadingImage = true;
      });
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
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
    } catch (err) {
      print(err);
      setState(() {
        _isLoadingImage = false;
      });
    }
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

  Widget _buildCategoryTagField() {
    return Tags(
      key: _tagStateKey,
      textField: TagsTextField(
          textStyle: TextStyle(fontSize: 15),
          hintText: "Adicionar skill, ex: Java",
          constraintSuggestion: false,
          suggestions: [],
          onSubmitted: (String str) {
            setState(() {
              _items.add(Item(title: str));
            });
          }),
      columns: 6,
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item.title,
          pressEnabled: false,
          customData: item.customData,
          combine: ItemTagsCombine.withTextBefore,
          icon: ItemTagsIcon(icon: Icons.add),
          onPressed: (i) => print(i),
          onLongPressed: (i) => print(i),
          removeButton: ItemTagsRemoveButton(onRemoved: () {
            setState(() {
              _items.removeAt(index);
            });

            return true;
          }),
        );
      },
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
              ? !_isLoadingImage
                  ? Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.all(15),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.photo),
                      ),
                    )
                  : Container(
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

  _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst
          .where((a) => a.active == true)
          .forEach((a) => _itemsTitle.add(a.title));
    return _itemsTitle.toList();
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
                      SizedBox(
                        height: 20,
                      ),
                      _buildDescriptionField(),
                      _buildCategoryTagField(),
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
                            final demanda = Demanda(
                                name: _name,
                                description: _description,
                                categories: _getAllItem(),
                                quantityParticipants: _quantityParticipants,
                                localization: _localization,
                                endDate: Timestamp.fromDate(_date),
                                startDate: Timestamp.now(),
                                urlImage: _urlImage,
                                isFinished: false);
                            if (!_isLoadingImage) {
                              demandService.saveDemandData(demanda);
                              Navigator.of(context).pushNamed("/navigation");
                            }
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
