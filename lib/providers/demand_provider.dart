import 'package:aplicai/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DemandProvider {
  Stream<List<UserEntity>> streamOfUsers(String childId, String parentId) {
    var ref = FirebaseFirestore.instance.collection("Demands")
                .doc(parentId)
                .collection("DemandList")
                .doc(parentId)
                .collection("Users");
    return ref.snapshots().map((list) => list.docs.map((doc) => UserEntity.fromJson(doc.data())).toList());
  }

}