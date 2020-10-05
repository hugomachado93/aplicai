import 'package:aplicai/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserEntity user;

  Future<UserEntity> getUserById(String id) async {
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(id).get();
    return UserEntity.fromJson(documentSnapshot.data());
  }

  Future<UserEntity> createInitialuserLogin(
      String uid, String displayName, String email) async {
    _db.collection("Users").doc(uid).set({"nome": displayName, "email": email});
  }
}
