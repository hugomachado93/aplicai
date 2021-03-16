import 'package:aplicai/bloc/signup_page_bloc.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupWithEmail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupWithEmailState();
  }
}

class _SignupWithEmailState extends State<SignupWithEmail> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _buildEmailField(SignupPageState state, BuildContext context) {
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
        onChanged: (value) {
          Provider.of<SignupPageBloc>(context, listen: false)
              .add(ValidateEmail(email: value));
        },
      ),
    );
  }

  _buildPasswordField(SignupPageState state, BuildContext context) {
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
              hintText: "Senha"),
          onChanged: (value) {
            Provider.of<SignupPageBloc>(context, listen: false)
                .add(ValidatePassword(password: value));
          },
        ));
  }

  _buildLoginButton(BuildContext context) {
    return Container(
      child: InkWell(
          child: Text("Já tem cadastro? Clique aqui para logar!"),
          onTap: () => _login(context)),
    );
  }

  _buildSignupButton(BuildContext context, SignupPageState state) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          child: Text("Cadastrar"),
          style: ElevatedButton.styleFrom(primary: Colors.blue),
          onPressed: () => Provider.of<SignupPageBloc>(context, listen: false)
              .add(SignupUser(
                  email: _emailController.text,
                  password: _passwordController.text))),
    );
  }

  _login(BuildContext context) {
    Provider.of<SignupPageBloc>(context, listen: false).add(LoginUser());
  }

  _signup(BuildContext context) {
    Provider.of<SignupPageBloc>(context, listen: false).add(SignupUser(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,
      leading: BackButton(color: Colors.black,),
      elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => SignupPageBloc(),
        child: BlocConsumer<SignupPageBloc, SignupPageState>(
          listener: (context, state) {
            if (state is ContinueSignup) {
              Navigator.of(context).pushNamed("/signup-start");
            } else if (state is GoToLoginPage) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            print(state.errorMessage);
            if (state is LoadingPageState) {
              return Center(
                child: CustomCircularProgressIndicator(),
              );
            } else if (state is SignupPageState) {
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
                          state.displayErrorMessage
                              ? Text(
                                  state.errorMessage,
                                  style: TextStyle(color: Colors.red),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSignupButton(context, state),
                              SizedBox(
                                height: 15,
                              ),
                              _buildLoginButton(context),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
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
