import 'package:aplicai/bloc/login_bloc.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:aplicai/service/user_service.dart';
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
        ));
  }

  _buildLoginButton(BuildContext context, LoginState state) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
          child: Text("Entrar"),
          color: Colors.blue,
          onPressed: () => _login(context)),
    );
  }

  _buildSignupButton(BuildContext context, LoginState state) {
    return Container(
      child: RaisedButton(
          child: Text("Não tem"), onPressed: () => _signup(context)),
    );
  }

  _login(BuildContext context) {
    Provider.of<LoginBloc>(context, listen: false).add(
        LoginUserSigninEvent(_emailController.text, _passwordController.text));
  }

  _signup(BuildContext context) {
    Provider.of<LoginBloc>(context, listen: false).add(LoginUserSignupEvent());
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginUserCreatedState) {
              Navigator.of(context).pushNamed("/signup-with-email");
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
                child: CustomCircularProgressIndicator(),
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
                          Column(
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

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }
}
