import 'package:cloud_firestore/cloud_firestore.dart';

class Demanda {
  String name;
  String categories;
  String description;
  Timestamp endDate;
  Timestamp startDate;
  String localization;
  String quantityParticipants;
  String parentId;
  String childId;
  String solicitationId;
  String urlImage;

  Demanda(this.name, this.categories, this.endDate, this.startDate, this.localization,
      this.quantityParticipants, this.description);

  Demanda.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    categories = json['categories'];
    description = json['description'];
    endDate = json['endDate'];
    startDate = json['startDate'];
    localization = json['localization'];
    quantityParticipants = json['quantityParticipants'];
    urlImage = json['urlImage'];
  }

  Map<String, dynamic> toJson() => {
        'categories': name,
        'description': description,
        'endDate': endDate,
        'localization': localization,
        'name': name,
        'quantityParticipants': quantityParticipants
      };
}
