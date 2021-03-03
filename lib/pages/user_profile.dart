import 'package:aplicai/bloc/user_profile_bloc.dart';
import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/pages/employer_profile.dart';
import 'package:aplicai/pages/student_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:aplicai/service/auth_service.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserProfilePageState();
  }
}

class _UserProfilePageState extends State<UserProfilePage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  AuthService authService = AuthService();
  UserService userService = UserService();
  StudentProfile studentProfile = StudentProfile();
  EmployerProfile employerProfile = EmployerProfile();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc()..add(GetUserTypeProfile()),
      child: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is UserProfileInitial || state is UserProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserProfileStudent) {
            return studentProfile.buildStudent(
                state.userEntity, context, authService);
          } else if (state is UserProfileEmployer) {
            return employerProfile.buildEmployer(
                state.empreendedor, context, authService);
          }
        },
      ),
    );
  }
}
