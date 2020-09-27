import 'package:aplicai/enum/userTypeEnum.dart';

class User {
  final String _name;
  final String _email;
  final String _cpf;
  final String _curso;
  final String _matricula;
  final String _linkedinUrl;
  final String _portfolioUrl;

  User(this._name, this._email, this._cpf, this._curso, this._matricula,
      this._linkedinUrl, this._portfolioUrl);

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
