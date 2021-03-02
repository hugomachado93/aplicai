import 'package:aplicai/enum/userTypeEnum.dart';

import 'demanda.dart';

class Empreendedor {
  String companyName;
  String email;
  String cnpj;
  String razaoSocial;
  String description;
  String linkedinUrl;
  String portfolioUrl;
  String urlImage;
  bool isFinished;
  List<Demanda> demandas;

  Empreendedor(
      {this.companyName,
      this.email,
      this.cnpj,
      this.razaoSocial,
      this.description,
      this.linkedinUrl,
      this.portfolioUrl,
      this.urlImage,
      this.isFinished});

  Empreendedor.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    email = json['email'];
    cnpj = json['cnpj'];
    razaoSocial = json['razaoSocial'];
    description = json['description'];
    linkedinUrl = json['linkedinUrl'];
    portfolioUrl = json['portfolioUrl'];
    description = json['description'];
    urlImage = json['urlImage'];
    isFinished = json['isFinished'];
  }

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'cnpj': cnpj,
        'razapSocial': razaoSocial,
        'description': description,
        'linkedinUrl': linkedinUrl,
        'portfolioUrl': portfolioUrl,
        'imageUrl': urlImage,
        'isFinished': isFinished,
        'type': UserTypeEnum.employer.toString().split('.').last
      };
}
