import 'package:aplicai/entity/demanda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  finishDemand(String parentId, String childId) async {
    var users = await _db
        .collection("Demands")
        .doc(parentId)
        .collection("DemandList")
        .doc(childId)
        .collection("Users").get();

    for(var user in users.docs) {
      await _db.collection("Users")
        .doc(user.id)
        .collection("Demands")
        .doc(childId)
        .update({
          'isFinished': true
        });
    }

    await _db
        .collection("Demands")
        .doc(parentId)
        .collection("DemandList")
        .doc(childId)
        .update({'isFinished': true});

  }
}
