import 'package:cloud_firestore/cloud_firestore.dart';

class Demanda {
  String name;
  List categories;
  String description;
  Timestamp endDate;
  Timestamp startDate;
  String localization;
  String quantityParticipants;
  String parentId;
  String childId;
  String solicitationId;
  String urlImage;
  bool isFinished;
  double similarity;

  Demanda(
      {this.name,
      this.categories,
      this.endDate,
      this.startDate,
      this.localization,
      this.quantityParticipants,
      this.description,
      this.urlImage,
      this.isFinished});

  Demanda.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    categories = json['categories'];
    description = json['description'];
    endDate = json['endDate'];
    startDate = json['startDate'];
    localization = json['localization'];
    quantityParticipants = json['quantityParticipants'];
    urlImage = json['urlImage'];
    isFinished = json['isFinished'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categories': categories,
        'endDate': endDate,
        'startDate': startDate,
        'localization': localization,
        'quantityParticipants': quantityParticipants,
        'urlImage': urlImage,
        'isFinished': isFinished
      };
}
