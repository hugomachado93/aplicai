import 'package:aplicai/enum/userTypeEnum.dart';

class UserEntity {
  String _name;
  String _email;
  String _cpf;
  String _curso;
  String _matricula;
  String _linkedinUrl;
  String _portfolioUrl;

  UserEntity(this._name, this._email, this._cpf, this._curso, this._matricula,
      this._linkedinUrl, this._portfolioUrl);

  UserEntity.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _email = json['categories'];
    _cpf = json['cpf'];
    _curso = json['curso'];
    _matricula = json['matricula'];
    _linkedinUrl = json['linkedinUrl'];
    _portfolioUrl = json['portfolioUrl'];
  }

  Map<String, dynamic> toJson() => {
        'name': _name,
        'email': _email,
        'cpf': _cpf,
        'curso': _curso,
        'matricula': _matricula,
        'linkedinUrl': _linkedinUrl,
        'portfolioUrl': _portfolioUrl,
        'type': UserTypeEnum.student.toString().split('.').last
      };
}
