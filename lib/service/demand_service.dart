import 'package:aplicai/bloc/explore_page_bloc.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/recommendation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DemandService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Demanda>> getDemand(
      int index, List<QueryDocumentSnapshot> demandList) {
    Demanda demanda = Demanda.fromJson(demandList[index].data());
    demanda.parentId = demandList[index].reference.parent.parent.id;
    demanda.childId = demandList[index].id;
    var ref = _db
        .collection("Demands")
        .doc(demanda.parentId)
        .collection("DemandList")
        .doc(demanda.childId)
        .collection("Users");
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Demanda.fromJson(doc.data())).toList());
  }

  Future<List<Demanda>> getActiveDemands() async {
    List<Demanda> listDemands = [];

    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString("userId");
    DocumentSnapshot documentSnapshot =
        await _db.collection("Recommendation").doc(userid).get();

    if (documentSnapshot.exists) {
      Recommendation recommendation =
          Recommendation.fromJson(documentSnapshot.data());
      for (DemandInfo demandInfo in recommendation.recomendedDemand) {
        documentSnapshot = await _db
            .collection("Demands")
            .doc(demandInfo.userOwnerId)
            .collection("DemandList")
            .doc(demandInfo.demandId)
            .get();

        final demanda = Demanda.fromJson(documentSnapshot.data());
        if (!demanda.isFinished) {
          demanda.childId = demandInfo.demandId;
          demanda.parentId = demandInfo.userOwnerId;
          demanda.similarity = demandInfo.similarity;
          listDemands.add(demanda);
        }
      }
    } else {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("DemandList")
          .where('isFinished', isEqualTo: false)
          .get();

      querySnapshot.docs.forEach((e) {
        var demanda = Demanda.fromJson(e.data());
        demanda.childId = e.id;
        demanda.parentId = e.reference.parent.parent.id;
        listDemands.add(demanda);
      });
    }

    return listDemands;
  }

  finishDemand(String parentId, String childId) async {
    var users = await _db
        .collection("Demands")
        .doc(parentId)
        .collection("DemandList")
        .doc(childId)
        .collection("Users")
        .get();

    for (var user in users.docs) {
      await _db
          .collection("Users")
          .doc(user.id)
          .collection("Demands")
          .doc(childId)
          .update({'isFinished': true});
    }

    await _db
        .collection("Users")
        .doc(parentId)
        .collection("Demands")
        .doc(childId)
        .update({'isFinished': true});

    await _db
        .collection("Demands")
        .doc(parentId)
        .collection("DemandList")
        .doc(childId)
        .update({'isFinished': true});
  }

  saveDemandData(Demanda demanda) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      DocumentReference documentReference = _db
          .collection("Demands")
          .doc(prefs.getString("userId"))
          .collection("DemandList")
          .doc();

      documentReference.set(demanda.toJson());

      _db
          .collection("Users")
          .doc(prefs.getString("userId"))
          .collection("Demands")
          .doc(documentReference.id)
          .set(demanda.toJson());
    } catch (ex) {
      print("Failed to create user $ex");
    }
  }
}
