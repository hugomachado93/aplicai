import 'package:aplicai/bloc/login_bloc.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService userService = UserService();

  Stream<UserEntity> get user {
    return _firebaseAuth.authStateChanges().map((User user) =>
        user != null ? UserEntity(userId: user.uid) : UserEntity(userId: null));
  }

  Future<User> getUserUidAuth() async {
    var googleUser = await _googleSignIn.signIn();
    var googleAuth = await googleUser.authentication;
    var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    var authResult = await _firebaseAuth.signInWithCredential(credential);
    var user = authResult.user;
    return user;
  }

  Future<UserLoginState> signInWithGoogle() async {
    try {
      var googleUser = await _googleSignIn.signIn();
      var googleAuth = await googleUser.authentication;
      var credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var authResult = await _firebaseAuth.signInWithCredential(credential);
      var userAuth = authResult.user;
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", userAuth.uid);
      UserEntity user = await userService.getUserById(userAuth.uid);
      if (user != null) {
        return UserLoginState(isValid: true, isFinished: user.isFinished);
      } else {
        await userService.createInitialuserLogin(userAuth.uid, userAuth.email);
        return UserLoginState(isValid: true, isFinished: user.isFinished);
      }
    } catch (ex) {
      print("Falha ao logar $ex");
      return UserLoginState(
          isValid: false, message: "Erro ao logar com a conta do Google");
    }
  }

  Future<UserLoginState> createUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userService.createInitialuserLogin(userCredential.user.uid, email);
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", userCredential.user.uid);
      return UserLoginState(isValid: true);
    } on FirebaseAuthException catch (err) {
      String message;
      switch (err.code) {
        case "email-already-in-use":
          message = "Email já está em uso";
          break;
        case "invalid-email":
          message = "Email invalido";
          break;
        case "weak-password":
          message = "Senha não é forte o suficiente";
          break;
        default:
          message = "Não foi possivel efetuar o cadastro";
          break;
      }
      return UserLoginState(isValid: false, message: message);
    } catch (err) {
      return UserLoginState(
          isValid: false, message: "Não foi possivel efetuar o cadastro");
    }
  }

  Future<UserLoginState> signinUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      UserEntity user = await userService.getUserById(userCredential.user.uid);
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", userCredential.user.uid);
      return UserLoginState(isValid: true, isFinished: user.isFinished);
    } on FirebaseAuthException catch (err) {
      String message;
      switch (err.code) {
        case "user-not-found":
          message = "O usuário não existe";
          break;
        case "invalid-email":
          message = "Email invalido";
          break;
        case "wrong-password":
          message = "Senha não está correta";
          break;
        default:
          message = "Não foi possivel efetuar o login";
          break;
      }
      return UserLoginState(isValid: false, message: message);
    } catch (err) {
      print(err);
      return UserLoginState(
          isValid: false, message: "Não foi possivel efetuar o login");
    }
  }

  logoutUser() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
