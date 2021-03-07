import 'package:aplicai/bloc/solicitation_detail_bloc.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SolicitationDetailPage extends StatefulWidget {
  Demanda demanda;
  SolicitationDetailPage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _SolicitationDetailPageState(demanda: demanda);
  }
}

class _SolicitationDetailPageState extends State<SolicitationDetailPage> {
  Demanda demanda;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  UserService userService = UserService();

  _SolicitationDetailPageState({this.demanda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) => SolicitationDetailBloc()
              ..add(GetUserSolicitationEvent(demanda: demanda)),
            child:
                BlocConsumer<SolicitationDetailBloc, SolicitationDetailState>(
                    listener: (context, state) {
              if (state is SolicitationAcceptState) {
                Navigator.of(context).pop();
              }
            }, builder: (context, state) {
              if (state is SolicitationDetailInitial ||
                  state is SolicitationDetailLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is SolicitationDetailLoaded) {
                return buildSolicitationDetailLoaded(state, context);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })));
  }

  Center buildSolicitationDetailLoaded(
      SolicitationDetailLoaded state, BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Suas Solicitações",
            style: TextStyle(fontSize: 30),
          ),
          Divider(
            thickness: 1,
          ),
          Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              state.solicitation.userEntity.urlImage),
                          fit: BoxFit.fill)),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          Expanded(
                              child: Text(state.solicitation.userEntity.name)),
                        ],
                      ),
                      Container(
                        child: RaisedButton(
                          onPressed: () {},
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("Ver perfil"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(state.solicitation.motivationText),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  width: 180,
                  child: RaisedButton(
                      child: Text("Aceitar"),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        Provider.of<SolicitationDetailBloc>(context,
                                listen: false)
                            .add(AcceptSolicitationEvent(demanda: demanda));
                      }),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Container(
                  width: 180,
                  child: RaisedButton(
                      child: Text("Recusar"),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        Provider.of<SolicitationDetailBloc>(context)
                            .add(RejectSolicitationEvent());
                        Navigator.of(context).pop();
                      }),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
