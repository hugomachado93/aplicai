import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserEntity user;

  Future<UserEntity> getUserById(String id) async {
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(id).get();
    if (documentSnapshot.data() == null) {
      return null;
    }
    return UserEntity.fromJson(documentSnapshot.data());
  }

  Future<UserEntity> createInitialuserLogin(
      String uid, String displayName, String email) async {
    _db.collection("Users").doc(uid).set({"nome": displayName, "email": email});
  }

  Future<List<UserEntity>> getAllUsersSolicitation(Demanda demanda) async {
    List<UserEntity> userEntityList = [];

    final refs = await _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .collection("Solicitation")
        .get();

    for (var ref in refs.docs) {
      var user = await _db.collection("Users").doc(ref.id).get();
      var userEntity = UserEntity.fromJson(user.data());
      userEntity.userId = ref.id;
      userEntityList.add(userEntity);
    }

    return userEntityList;
  }
}
