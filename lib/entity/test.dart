class Test {
  String nome;

  Test({this.nome});

  Test.fromJson(Map<String, dynamic> json) {
    nome = json['name'];
  }
}