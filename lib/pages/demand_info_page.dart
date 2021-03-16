import 'package:aplicai/bloc/demand_info_bloc.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/providers/demand_provider.dart';
import 'package:aplicai/service/demand_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DemandInfoPage extends StatefulWidget {
  final Demanda demanda;

  DemandInfoPage({this.demanda});

  @override
  State<StatefulWidget> createState() {
    return _DemandInfoPageState(demanda: this.demanda);
  }
}

class _DemandInfoPageState extends State<DemandInfoPage> {
  Demanda demanda;
  _DemandInfoPageState({this.demanda});

  DemandProvider demandProvider = new DemandProvider();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
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
          _textBuilder(Icons.work, endDateFormated()),
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

  int calculateDaysToEndDemand() {
    return demanda.endDate.toDate().difference(DateTime.now()).inDays;
  }

  double progressBarCalculation() {
    int daysToEnd = calculateDaysToEndDemand();
    int totalNumOfDays =
        demanda.endDate.toDate().difference(demanda.startDate.toDate()).inDays;
    var date = 1 - ((daysToEnd) / totalNumOfDays);
    return date.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DemandInfoBloc()
          ..add(GetAllUsers(
              employerId: demanda.parentId,
              studentUserListId: demanda.childId)),
        child: BlocConsumer<DemandInfoBloc, DemandInfoState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is DemandInfoInitial || state is DemandInfoLoading) {
                return Center(child: CustomCircularProgressIndicator());
              } else if (state is DemandInfoAllUsers) {
                return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      leading: BackButton(
                        color: Colors.black,
                      ),
                      elevation: 0,
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _createTop(),
                              SizedBox(
                                height: 30,
                              ),
                              calculateDaysToEndDemand() > 1
                                  ? Text(
                                      "Faltam ${calculateDaysToEndDemand()} dias")
                                  : Text("Prazo para a entrega finalizado"),
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 15,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: LinearProgressIndicator(
                                    value: progressBarCalculation(),
                                  ),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        "Entrega do projeto\n           ${endDateFormated()}"),
                                    Icon(
                                      Icons.calendar_today,
                                      size: 50,
                                    )
                                  ]),
                              state.currentUserType == 'employer'
                                  ? Divider(
                                      color: Colors.black,
                                    )
                                  : Container(),
                              state.currentUserType == 'employer'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 170,
                                          child: RaisedButton(
                                              color: Colors.blue,
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    "/solicitation",
                                                    arguments: demanda);
                                              },
                                              child: Text("Ver solicitações")),
                                        ),
                                        Container(
                                            width: 170,
                                            child: RaisedButton(
                                                color: Colors.blue,
                                                onPressed: () async {
                                                  DemandService().finishDemand(
                                                      demanda.parentId,
                                                      demanda.childId);
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    Text("Concluir demanda")))
                                      ],
                                    )
                                  : Container(),
                              Divider(
                                color: Colors.black,
                              ),
                              Text(
                                "Participantes",
                                style: TextStyle(fontSize: 20),
                              ),
                              state.students.length != 0
                                  ? Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      child: Expanded(
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: state.students.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      image: NetworkImage(state
                                                          .students[index]
                                                          .urlImage),
                                                      fit: BoxFit.fill)),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              width: 30,
                                            );
                                          },
                                        ),
                                      ))
                                  : Container(
                                      child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                            "Ainda não existem participantes..."),
                                        SizedBox(
                                          height: 15,
                                        )
                                      ],
                                    )),
                              Divider(color: Colors.black),
                              Text(
                                "Contatos",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(children: [
                                Icon(Icons.email),
                                Expanded(
                                    child: Text(
                                        "${state.empreendedor.companyName}:")),
                                Expanded(
                                    child: Text("${state.empreendedor.email}")),
                              ]),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.students.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Icon(Icons.email),
                                        Expanded(
                                          child: Container(
                                            width: 140,
                                            child: Text(
                                              "${state.students[index].name}",
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 200,
                                            child: Text(
                                                "${state.students[index].email}"),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                            ],
                          )),
                    ));
              }
            }));
  }
}
