class Notify {
  String notification;
  String name;
  String imageUrl;
  Notify({this.notification, this.name, this.imageUrl});

  Notify.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    name = json['name'];
    imageUrl = json['imageUrl'];
  }
}
