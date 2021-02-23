import 'package:aplicai/enum/userTypeEnum.dart';

class Empreendedor {
  final String companyName;
  final String email;
  final String cnpj;
  final String razaoSocial;
  final String desciption;
  final String linkedinUrl;
  final String portfolioUrl;
  final bool isFinished;

  Empreendedor(
      {this.companyName,
      this.email,
      this.cnpj,
      this.razaoSocial,
      this.desciption,
      this.linkedinUrl,
      this.portfolioUrl,
      this.isFinished});

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'cnpj': cnpj,
        'razapSocial': razaoSocial,
        'description': desciption,
        'linkedinUrl': linkedinUrl,
        'portfolioUrl': portfolioUrl,
        'isFinished': isFinished,
        'type': UserTypeEnum.employer.toString().split('.').last
      };
}
