import 'package:flutter/material.dart';

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

  Widget _buildSenhaField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Senha"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Nome invalido";
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
          return "Nome invalido";
        }
      },
      onSaved: (value) => {_curso = value},
    );
  }

  Widget _buildMatriculaField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Matricula PUC-Rio"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Nome invalido";
        }
      },
      onSaved: (value) => {_matricula = value},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text("Aluno"),
                _buildNameField(),
                _buildEmailField(),
                _buildSenhaField(),
                _buildCursoField(),
                _buildMatriculaField(),
                RaisedButton(
                  child: Text("Enviar"),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                  },
                )
              ],
            )),
      ),
    );
  }
}
