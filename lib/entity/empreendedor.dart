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
        'name': _companyName,
        'email': _email,
        'cpf': _cnpj,
        'curso': _razaoSocial,
        'matricula': _desciption,
        'linkedinUrl': _linkedinUrl,
        'portfolioUrl': _portfolioUrl
      };
}
