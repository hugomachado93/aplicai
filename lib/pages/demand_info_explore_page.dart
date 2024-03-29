import 'package:aplicai/bloc/demand_info_explore_bloc.dart';
import 'package:aplicai/commons/commons.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DemandInfoExplorePage extends StatefulWidget {
  final Demanda demanda;

  DemandInfoExplorePage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _DemandInfoExplorePageState(demanda: this.demanda);
  }
}

class _DemandInfoExplorePageState extends State<DemandInfoExplorePage> {
  Demanda demanda;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String _demandPictureUrl;

  _DemandInfoExplorePageState({this.demanda});

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Flexible(child: Text(text))]);
  }

  Widget _createTop() {
    return Row(children: [
      CachedNetworkImage(
        imageUrl: demanda.urlImage,
        imageBuilder: (context, imageProvider) => Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(demanda.name),
          Divider(color: Colors.black),
          _textBuilder(Icons.work, Commons.getDemandDate(demanda.endDate)),
          _textBuilder(Icons.folder, demanda.categories.toString()),
          _textBuilder(Icons.location_on, demanda.localization),
        ]),
      ),
      SizedBox(
        width: 10,
      ),
    ]);
  }

  String endDateFormated() {
    var dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(demanda.endDate.toDate());
  }

  Widget _bottomDescriptions(IconData icon, String title, String description) {
    return Row(
      children: [
        Icon(
          icon,
          size: 40,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title), Text(description)],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.black,
        ),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => DemandInfoExploreBloc()
          ..add(GetCurrentUserAndEmployerData(employerId: demanda.parentId)),
        child: BlocConsumer<DemandInfoExploreBloc, DemandInfoExploreState>(
            listener: (context, state) {
          if (state is DemandInfoExploreEmployerPerfil) {
            Navigator.of(context)
                .pushNamed("/employer-info", arguments: state.empreendedor)
                .whenComplete(() =>
                    Provider.of<DemandInfoExploreBloc>(context, listen: false)
                        .add(GetCurrentUserAndEmployerData(
                            employerId: demanda.parentId)));
          }
        }, builder: (context, state) {
          if (state is DemandInfoExploreInitial ||
              state is DemandInfoExploreLoading) {
            return CustomCircularProgressIndicator();
          } else if (state is DemandInfoExploreError) {
            return Center(
              child: Text("Error"),
            );
          } else if (state is DemandInfoExploreGetUserAndEmployerData) {
            return buildDemandInfoExploreGetUserAndEmployerData(state, context);
          } else if (state is DemandInfoExploreEmployerPerfil) {
            return Container();
          }
        }),
      ),
    );
  }

  SingleChildScrollView buildDemandInfoExploreGetUserAndEmployerData(
      DemandInfoExploreGetUserAndEmployerData state, BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _createTop(),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 15),
                  state.empreendedor != null
                      ? Center(
                          child: InkWell(
                          onTap: () {
                            Provider.of<DemandInfoExploreBloc>(context,
                                    listen: false)
                                .add(GoToEmployerPerfil(
                                    empreendedor: state.empreendedor));
                          },
                          child: Text(
                            "Ver perfil do empreendimento",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 18,
                            ),
                          ),
                        ))
                      : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Descrição:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(demanda.description),
                  Divider(
                    height: 50,
                    thickness: 1,
                  ),
                  _bottomDescriptions(Icons.calendar_today,
                      "Fim das inscrições", endDateFormated()),
                  _bottomDescriptions(
                      Icons.watch_later, "Duração", "Média, até 1 mês"),
                  _bottomDescriptions(Icons.group, "Grupo",
                      "${demanda.quantityParticipants} participantes"),
                  _bottomDescriptions(Icons.folder, "Categorias",
                      demanda.categories.toString()),
                  SizedBox(
                    height: 15,
                  ),
                  state.empreendedor != null && !demanda.isFinished
                      ? Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    "/demand-subscription",
                                    arguments: demanda);
                              },
                              child: Text(
                                "Quero me increver!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ])));
  }
}
