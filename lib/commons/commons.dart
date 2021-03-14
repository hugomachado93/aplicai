import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class Commons {
  static getDemandDate(Timestamp timestamp) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(timestamp.toDate());
  }
}
