class Notify {
  String notification;
  Notify({this.notification});

  Notify.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
  }

}