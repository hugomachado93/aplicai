import 'package:equatable/equatable.dart';

class Notify extends Equatable {
  String notification;
  String name;
  String imageUrl;
  String type;
    
  Notify({this.notification, this.name, this.imageUrl, this.type});

  Notify.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    type = json['type'];
  }

  @override
  List<Object> get props => [notification, name, imageUrl, type];
}
