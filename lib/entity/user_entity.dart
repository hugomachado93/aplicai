import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/enum/userTypeEnum.dart';

class UserEntity {
  bool isFinished;
  String userId;
  String name;
  String email;
  String cpf;
  String curso;
  String matricula;
  String description;
  List categories;
  String urlImage;
  String linkedinUrl;
  String portfolioUrl;
  List<Demanda> demandas;

  UserEntity(
      {this.userId,
      this.name,
      this.email,
      this.cpf,
      this.curso,
      this.matricula,
      this.description,
      this.urlImage,
      this.categories,
      this.linkedinUrl,
      this.portfolioUrl,
      this.isFinished});

  UserEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    cpf = json['cpf'];
    curso = json['curso'];
    matricula = json['matricula'];
    linkedinUrl = json['linkedinUrl'];
    portfolioUrl = json['portfolioUrl'];
    categories = json['categories'];
    description = json['description'];
    urlImage = json['urlImage'];
    isFinished = json['isFinished'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'cpf': cpf,
        'curso': curso,
        'matricula': matricula,
        'description': description,
        'urlImage': urlImage,
        'categories': categories,
        'linkedinUrl': linkedinUrl,
        'portfolioUrl': portfolioUrl,
        'isFinished': isFinished,
        'type': UserTypeEnum.student.toString().split('.').last
      };
}
