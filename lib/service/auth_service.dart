import 'package:aplicai/bloc/login_bloc.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<SignupError> createUser(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return SignupError(isValid: true);
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
      return SignupError(isValid: false, message: message);
    } catch (err) {
      return SignupError(
          isValid: false, message: "Não foi possivel efetuar o cadastro");
    }
  }

  logoutUser() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
