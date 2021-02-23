import 'dart:ui';
import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tags/flutter_tags.dart';
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
  String _cpf;
  String _curso;
  String _matricula;
  String _linkedinUrl;
  String _portfolioUrl;
  String _urlImage;
  String _description;
  File _image;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  SharedPreferences prefs;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List _items = [];
  List<String> _itemsTitle = [];

  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });

    var prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    Reference reference = _storage.ref().child(
        "/demands/$userId${DateTime.now().toUtc().millisecondsSinceEpoch}");
    UploadTask storageUploadTask = reference.putFile(_image);

    TaskSnapshot storageTaskSnapshot = await storageUploadTask;

    _urlImage = await storageTaskSnapshot.ref.getDownloadURL();
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

  Widget _buildCpfField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "CPF"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Cpf invalido";
        }
      },
      onSaved: (value) => {_cpf = value},
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
          hintText: "Descrição",
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  Widget _buildLinkedinLinkField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Url Linkedin (Opcional)"),
      validator: null,
      onSaved: (value) => {_linkedinUrl = value},
    );
  }

  Widget _buildPortfolioLinkField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Url Portfolio (Opcional)"),
      validator: null,
      onSaved: (value) => {_portfolioUrl = value},
    );
  }

  Widget _buildPerfilImageField() {
    return InkWell(
      onTap: _getImage,
      child: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("Selecionar imagem de perfil"),
          Container(
            color: Colors.transparent,
          ),
          _image == null
              ? Container(
                  height: 100,
                  width: 100,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.photo,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 1.0),
                      image: DecorationImage(
                          image: FileImage(_image), fit: BoxFit.fill)))
        ]),
      ),
    );
  }

  _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst
          .where((a) => a.active == true)
          .forEach((a) => _itemsTitle.add(a.title));
    return _itemsTitle.toList();
  }

  _saveUserData(String userId) async {
    try {
      if (_urlImage != null) {
        var user = UserEntity(
            name: _name,
            cpf: _cpf,
            curso: _curso,
            matricula: _matricula,
            description: _description,
            urlImage: _urlImage,
            categories: _getAllItem(),
            linkedinUrl: _linkedinUrl,
            portfolioUrl: _portfolioUrl,
            isFinished: true);
        _db.collection("Users").doc(userId).update(user.toJson());

        _db
            .collection("Users")
            .doc(userId)
            .collection("Notifications")
            .doc()
            .set({
          "name": _name,
          "imageUrl": "",
          "notification": "Seja bem vindo ao Aplicai",
          "type": "signup"
        });
        Navigator.of(context).pushNamed("/navigation");
      }
    } catch (ex) {
      print("Failed to create user $ex");
    }
  }

  _buildCategoryTagField() {
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

  @override
  Widget build(BuildContext context) {
    UserEntity userEntity = Provider.of<UserEntity>(context);
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
                  color: Colors.blueGrey,
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
                      _buildCpfField(),
                      _buildCursoField(),
                      _buildMatriculaField(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDescriptionField(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildCategoryTagField(),
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
                            _saveUserData(userEntity.userId);
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
