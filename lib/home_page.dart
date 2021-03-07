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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _buildEmailField(LoginState state, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(30, 0, 0, 255),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          icon: Icon(Icons.email),
          border: InputBorder.none,
          hintText: "Email",
        ),
        // errorText: !state.isEmailValid ? "Email invalido" : null),
        onChanged: (value) {
          Provider.of<LoginBloc>(context, listen: false)
              .add(LoginEmailEvent(value));
        },
      ),
    );
  }

  _buildPasswordField(LoginState state, BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(30, 0, 0, 255),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            border: InputBorder.none,
            hintText: "Senha",
          ),
          // errorText: !state.isPasswordValid ? "Senha invalida" : null),
          onChanged: (value) {
            Provider.of<LoginBloc>(context, listen: false)
                .add(LoginPasswordEvent(value));
          },
        ));
  }

  _buildLoginButton(BuildContext context, LoginState state) {
    return Container(
      child: RaisedButton(
          child: Text("Login"),
          onPressed: state.isValid ? () => _login(context) : null),
    );
  }

  _buildSignupButton(BuildContext context, LoginState state) {
    return Container(
      child: RaisedButton(
          child: Text("Signup"),
          onPressed: state.isValid ? () => _signup(context) : null),
    );
  }

  _login(BuildContext context) {
    Provider.of<LoginBloc>(context, listen: false).add(
        LoginUserSigninEvent(_emailController.text, _passwordController.text));
  }

  _signup(BuildContext context) {
    Provider.of<LoginBloc>(context, listen: false).add(
        LoginUserSignupEvent(_emailController.text, _passwordController.text));
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginUserCreatedState) {
              Navigator.of(context).pushNamed("/signup-start");
            } else if (state is LoginUserFinishedState) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/navigation", (Route<dynamic> route) => false);
            } else if (state is LoginUserNotFinishedState) {
              Navigator.of(context).pushNamed("/signup-start");
            }
          },
          builder: (context, state) {
            if (state is LoginLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoginState) {
              return SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          _buildEmailField(state, context),
                          SizedBox(
                            height: 5,
                          ),
                          _buildPasswordField(state, context),
                          SizedBox(
                            height: 10,
                          ),
                          !state.userLoginState.isValid
                              ? Text(
                                  state.userLoginState.message,
                                  style: TextStyle(color: Colors.red),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildLoginButton(context, state),
                              _buildSignupButton(context, state),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          RaisedButton(
                              child: Text("Entrar com o google"),
                              onPressed: () {
                                Provider.of<LoginBloc>(context, listen: false)
                                    .add(LoginGoogleEvent());
                              }),
                        ],
                      ),
                    )),
              );
            }
          },
        ),
      ),
    );
  }
}
