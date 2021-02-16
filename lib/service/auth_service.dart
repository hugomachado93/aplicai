import 'package:aplicai/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<UserEntity> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((User user) => user != null ? UserEntity(userId: user.uid) : UserEntity(userId: null));
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

  logoutUser() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
