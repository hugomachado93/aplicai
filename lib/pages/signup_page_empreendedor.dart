import 'dart:ui';
import 'package:aplicai/bloc/image_picker_bloc.dart';
import 'package:aplicai/bloc/signup_bloc.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/enum/userTypeEnum.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
  String _cnpj;
  String _razaoSocial;
  String _description;
  String _linkedinUrl;
  String _portfolioUrl;
  String _urlImage;
  File _image;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  SharedPreferences prefs;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final picker = ImagePicker();

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
      decoration: InputDecoration(labelText: "Razão Social (Opcional)"),
      onSaved: (value) => {_razaoSocial = value},
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

  Widget _buildLinkedinLinkField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Url Linkedin (Opcional)"),
      onSaved: (value) => {_linkedinUrl = value},
    );
  }

  Widget _buildPortfolioLinkField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Url Portfolio (Opcional)"),
      onSaved: (value) => {_portfolioUrl = value},
    );
  }

  Widget _buildPerfilImageField() {
    return InkWell(
      onTap: () => Provider.of<ImagePickerBloc>(context, listen: false)
          .add(PickImageEvent()),
      child: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("Selecionar imagem de perfil"),
          Container(
            color: Colors.transparent,
          ),
          BlocBuilder<ImagePickerBloc, ImagePickerState>(
              builder: (context, state) {
            if (state is ImagePickerInitial) {
              return Container(
                height: 100,
                width: 100,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Icons.photo,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              );
            } else if (state is ImageLoadedState) {
              _urlImage = state.urlImage;
              return Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 1.0),
                      image: DecorationImage(
                          image: MemoryImage(state.image), fit: BoxFit.fill)));
            } else if (state is ImageLoadingState) {
              return CircularProgressIndicator();
            }
          })
        ]),
      ),
    );
  }

  _saveUserData() async {
    try {
      prefs = await SharedPreferences.getInstance();
      if (_urlImage != null) {
        _db.collection("Users").doc(prefs.getString("userId")).update({
          "companyName": _companyName,
          "cnpj": _cnpj,
          "razaoSocial": _razaoSocial,
          "description": _description,
          "linkedinUrl": _linkedinUrl,
          "portfolioUrl": _portfolioUrl,
          "type": UserTypeEnum.employer.toString().split('.').last,
          "urlImage": _urlImage,
          "isFinished": true
        });
        Navigator.of(context)..pushNamed("/navigation");
      }
    } catch (ex) {
      print("Failed to create user $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignupBloc(userService: userService),
        child: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is SignupLoadedState) {
              return CustomCircularProgressIndicator();
            } else {
              return SingleChildScrollView(
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
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                    ),
                    Container(
                      margin: EdgeInsets.all(24),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildCompanyNameField(),
                              _buildCnpjField(),
                              _buildRazaoSocialField(),
                              SizedBox(
                                height: 30,
                              ),
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
              );
            }
          },
        ),
      ),
    );
  }
}
