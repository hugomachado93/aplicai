import 'package:aplicai/bloc/explore_page_bloc.dart';
import 'package:aplicai/commons/commons.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/demand_service.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExplorePageState();
  }
}

class _ExplorePageState extends State<ExplorePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  Widget _textListBuilder(IconData icon, List listText) {
    return Row(children: [
      Icon(icon),
      SizedBox(
        width: 10,
      ),
      Expanded(
          child: Row(
              children: listText
                  .map((e) => Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ))
                  .toList()))
    ]);
  }

  Stream<QuerySnapshot> _getDemandsFilteredForUser() {
    return _db
        .collectionGroup("DemandList")
        .where('isFinished', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(Object context) {
    DemandService demandService = Provider.of<DemandService>(context);
    return Scaffold(
        body: BlocProvider(
            create: (context) => ExplorePageBloc(demandService: demandService)
              ..add(GetActiveDemands()),
            child: BlocConsumer<ExplorePageBloc, ExplorePageState>(
                listener: (context, state) {
              if (state is ClickDemandState) {
                Navigator.of(context)
                    .pushNamed("/demand-info-explore", arguments: state.demanda)
                    .whenComplete(() =>
                        Provider.of<ExplorePageBloc>(context, listen: false)
                            .add(GetActiveDemands()));
              }
            }, builder: (context, state) {
              if (state is ExplorePageInitial || state is LoadingPageState) {
                return CustomCircularProgressIndicator();
              } else if (state is LoadedPageState) {
                return Container(
                    child: Center(
                        child: Column(children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      SizedBox(width: 15),
                      Text("Explorar", style: TextStyle(fontSize: 30))
                    ]),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: state.demandas.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Provider.of<ExplorePageBloc>(context,
                                        listen: false)
                                    .add(ClickDemand(
                                        demanda: state.demandas[index]));
                              },
                              child: Card(
                                color: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                margin: EdgeInsets.all(15),
                                child: Container(
                                    child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: state.demandas[index].urlImage,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill)),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(state.demandas[index].name),
                                            Divider(
                                              height: 5,
                                              thickness: 1,
                                            ),
                                            _textBuilder(
                                                Icons.calendar_today,
                                                Commons.getDemandDate(state
                                                        .demandas[index]
                                                        .endDate)
                                                    .toString()),
                                            _textListBuilder(
                                                Icons.folder,
                                                state.demandas[index]
                                                    .categories),
                                            _textBuilder(
                                                Icons.location_on,
                                                state.demandas[index]
                                                    .localization),
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                )),
                              ),
                            );
                          }))
                ])));
              } else if (state is ClickDemandState) {
                return Container();
              }
            })));
  }
}
