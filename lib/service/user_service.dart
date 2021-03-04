import 'package:aplicai/bloc/demand_info_bloc.dart';
import 'package:aplicai/bloc/demand_info_explore_bloc.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/empreendedor.dart';
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

  Future<UserEntity> createInitialuserLogin(String uid, String email) async {
    _db.collection("Users").doc(uid).set({"email": email, "isFinished": false});
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

  Stream<String> getUserType(String uid) {
    return _db
        .collection("Users")
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data()['type']);
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

  Future<QuerySnapshot> getUserNotifications(UserEntity userEntity) async {
    return await _db
        .collection("Users")
        .doc(userEntity.userId)
        .collection("Notifications")
        .get();
  }

  Stream<int> getUserNumNotifications(UserEntity userEntity) {
    return _db
        .collection("Users")
        .doc(userEntity.userId)
        .collection("Notifications")
        .snapshots()
        .map((event) => event.docs.length);
  }

  Future<UserEntity> getUserFinishedDemands() async {
    final pref = await SharedPreferences.getInstance();

    List<Demanda> demandas = [];

    final userId = pref.getString("userId");
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(userId).get();

    var user = UserEntity.fromJson(documentSnapshot.data());
    QuerySnapshot querySnapshot = await _db
        .collection("Users")
        .doc(userId)
        .collection("Demands")
        .where('isFinished', isEqualTo: true)
        .get();
    querySnapshot.docs.forEach((element) {
      demandas.add(Demanda.fromJson(element.data()));
    });
    user.demandas = demandas;
    return user;
  }

  Future getUserTypeFuture() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(userId).get();
    return documentSnapshot.data()['type'];
  }

  Future<UserEntity> getUserStudentAndFinishedDemands() async {
    final pref = await SharedPreferences.getInstance();

    List<Demanda> demandas = [];
    final userId = pref.getString("userId");
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(userId).get();
    UserEntity userEntity = UserEntity.fromJson(documentSnapshot.data());

    QuerySnapshot querySnapshot = await _db
        .collection("Users")
        .doc(userId)
        .collection("Demands")
        .where('isFinished', isEqualTo: true)
        .get();
    querySnapshot.docs.forEach((element) {
      demandas.add(Demanda.fromJson(element.data()));
    });
    userEntity.demandas = demandas;
    return userEntity;
  }

  Future<Empreendedor> getUserEmpolyerAndFinishedDemands() async {
    final pref = await SharedPreferences.getInstance();

    List<Demanda> demandas = [];
    final userId = pref.getString("userId");
    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(userId).get();
    Empreendedor empreendedor = Empreendedor.fromJson(documentSnapshot.data());

    QuerySnapshot querySnapshot = await _db
        .collection("Users")
        .doc(userId)
        .collection("Demands")
        .where('isFinished', isEqualTo: true)
        .get();
    querySnapshot.docs.forEach((element) {
      demandas.add(Demanda.fromJson(element.data()));
    });
    empreendedor.demandas = demandas;
    return empreendedor;
  }

  Future<DemandInfoAllUsers> getAllUsersFromProject(
      String employerId, String studentUserListId) async {
    List<UserEntity> students = [];

    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");

    QuerySnapshot querySnapshot = await _db
        .collection("Demands")
        .doc(employerId)
        .collection("DemandList")
        .doc(studentUserListId)
        .collection("Users")
        .get();

    querySnapshot.docs.forEach((element) {
      students.add(UserEntity.fromJson(element.data()));
    });

    DocumentSnapshot documentSnapshot =
        await _db.collection("Users").doc(employerId).get();
    Empreendedor empreendedor = Empreendedor.fromJson(documentSnapshot.data());

    documentSnapshot = await _db.collection("Users").doc(userId).get();

    final String type = documentSnapshot.data()['type'];

    return DemandInfoAllUsers(
        empreendedor: empreendedor, students: students, currentUserType: type);
  }

  Future<DemandInfoExploreGetUserAndEmployerData> getCurrentUserAndEmployerData(
      String employerId) async {
    List<Demanda> demandas = [];
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    final userData = await _db.collection("Users").doc(userId).get();
    final userType = userData.data()['type'];

    if (userType != 'employer') {
      DocumentSnapshot documentSnapshot =
          await _db.collection("Users").doc(employerId).get();
      Empreendedor empreendedor =
          Empreendedor.fromJson(documentSnapshot.data());

      QuerySnapshot querySnapshot = await _db
          .collection("Users")
          .doc(employerId)
          .collection("Demands")
          .get();
      querySnapshot.docs.forEach((element) {
        var demanda = Demanda.fromJson(element.data());
        demanda.parentId = employerId;
        demandas.add(demanda);
      });

      empreendedor.demandas = demandas;

      return DemandInfoExploreGetUserAndEmployerData(
          empreendedor: empreendedor);
    } else {
      return DemandInfoExploreGetUserAndEmployerData();
    }
  }
}
