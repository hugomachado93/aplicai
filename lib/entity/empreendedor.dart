import 'package:aplicai/enum/userTypeEnum.dart';

class Empreendedor {
  String _companyName;
  String _email;
  String _cnpj;
  String _razaoSocial;
  String _desciption;
  String _linkedinUrl;
  String _portfolioUrl;

  Empreendedor(this._companyName, this._email, this._cnpj, this._razaoSocial,
      this._desciption, this._linkedinUrl, this._portfolioUrl);

  Map<String, dynamic> toJson() => {
        'companyName': _companyName,
        'email': _email,
        'cnpj': _cnpj,
        'razapSocial': _razaoSocial,
        'description': _desciption,
        'linkedinUrl': _linkedinUrl,
        'portfolioUrl': _portfolioUrl,
        'type': UserTypeEnum.employer.toString().split('.').last
      };
}
