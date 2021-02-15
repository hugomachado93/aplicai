import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/test.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/entity/notify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
    _db
        .collection("Users")
        .doc(uid)
        .set({"nome": displayName, "email": email, "isFinished": false});
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

  Stream<Test> getUserInfo(String uid) {
    return _db
        .collection("Users")
        .doc(uid)
        .snapshots()
        .map((doc) => Test.fromJson(doc.data()));
  }

  Stream<List<Notify>> streamNotifications(String uid) {
    return _db
        .collection("Users")
        .doc(uid)
        .collection("Notifications")
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => Notify.fromJson(doc.data())).toList());
  }

  Stream<QuerySnapshot> getUserNotifications(UserEntity userEntity) {
    print("Userid ${userEntity}");
    return _db
        .collection("Users")
        .doc(userEntity.userId)
        .collection("Notifications")
        .snapshots();
  }

  Future<int> getUserNumNotifications() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    var notifications = await _db
        .collection("Users")
        .doc(userId)
        .collection("Notifications")
        .get();
    return notifications.docs.length;
  }

  Future<UserEntity> getUserProfile() async {
    final pref = await SharedPreferences.getInstance();

    List<Demanda> demandas = [];

    final userId = pref.getString("userId");
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(userId).get();
    var user = UserEntity.fromJson(documentSnapshot.data());
    QuerySnapshot querySnapshot =
        await _db.collection("Users").doc(userId).collection("Demands").get();
    querySnapshot.docs.forEach((element) {
      demandas.add(Demanda.fromJson(element.data()));
    });
    user.demandas = demandas;
    return user;
  }
}
