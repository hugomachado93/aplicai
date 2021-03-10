import 'package:aplicai/bloc/image_picker_bloc.dart';
import 'package:aplicai/bloc/signup_bloc.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:aplicai/service/demand_service.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aplicai/route_generator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/demand_info_explore_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: AuthService().user),
        RepositoryProvider<UserService>(create: (context) => UserService()),
        RepositoryProvider<DemandService>(create: (context) => DemandService()),
        BlocProvider(
            create: (context) => ImagePickerBloc(userService: UserService())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
