class Notify {
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
}
