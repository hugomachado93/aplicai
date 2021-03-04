import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/pages/employer_profile.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmployerInfo extends StatelessWidget {
  Empreendedor empreendedor;

  EmployerInfo({this.empreendedor});

  EmployerProfile employerProfile = EmployerProfile();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return employerProfile.buildEmployerInfo(
        empreendedor, context, authService);
  }
}
