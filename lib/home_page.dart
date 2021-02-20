import 'package:aplicai/bloc/login_bloc.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String _email;
  String _password;

  Future _signInWithGoogle(context) async {
    try {
      setState(() {
        isLoading = true;
      });

      var userAuth = await authService.getUserUidAuth();
      UserEntity user = await userService.getUserById(userAuth.uid);
      prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", userAuth.uid);

      if (user != null && user.isFinished) {
        print("usuario já cadastrado ${user}");

        Navigator.of(context).pushNamed("/navigation");
      } else {
        print("usuario sem login");
        await userService.createInitialuserLogin(
            userAuth.uid, userAuth.displayName, userAuth.email);
        Navigator.of(context).pushNamed("/signup-start");
      }
    } catch (ex) {
      print("Falha ao logar $ex");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _buildEmailField(LoginState state, BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Email",
          errorText: !state.isEmailValid ? "Email invalido" : null),
      onChanged: (value) {
        _email = value;
        Provider.of<LoginBloc>(context, listen: false)
            .add(LoginEmailEvent(value));
      },
    );
  }

  _buildPasswordField(LoginState state, BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Senha",
          errorText: !state.isPasswordValid ? "Senha invalida" : null),
      onChanged: (value) {
        _password = value;
        Provider.of<LoginBloc>(context, listen: false)
            .add(LoginPasswordEvent(value));
      },
    );
  }

  _buildLoginButton(LoginState state) {
    return Container(
      child: RaisedButton(
          child: Text("Login"), onPressed: state.isValid ? _login : null),
    );
  }

  _buildSignupButton(LoginState state) {
    return Container(
      child: RaisedButton(
          child: Text("Signup"), onPressed: state.isValid ? _signup : null),
    );
  }

  _login() {
    print("Logado");
  }

  _signup() {
    authService.createUser(_email, _password);
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
              margin: EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    _buildEmailField(state, context),
                    _buildPasswordField(state, context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLoginButton(state),
                        _buildSignupButton(state),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            child: Text("Entrar com o google"),
                            onPressed: () async {
                              await _signInWithGoogle(context);
                            }),
                  ],
                ),
              ));
        },
      ),
    ));
  }
}
