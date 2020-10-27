import 'package:aplicai/enum/userTypeEnum.dart';

class UserEntity {
  String name;
  String email;
  String cpf;
  String curso;
  String matricula;
  String linkedinUrl;
  String portfolioUrl;

  UserEntity(this.name, this.email, this.cpf, this.curso, this.matricula,
      this.linkedinUrl, this.portfolioUrl);

  UserEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    cpf = json['cpf'];
    curso = json['curso'];
    matricula = json['matricula'];
    linkedinUrl = json['linkedinUrl'];
    portfolioUrl = json['portfolioUrl'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'cpf': cpf,
        'curso': curso,
        'matricula': matricula,
        'linkedinUrl': linkedinUrl,
        'portfolioUrl': portfolioUrl,
        'type': UserTypeEnum.student.toString().split('.').last
      };
}
