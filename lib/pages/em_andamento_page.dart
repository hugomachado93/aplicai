import 'package:aplicai/bloc/em_andamento_bloc.dart';
import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmAndamentoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmAndamentoPageState();
  }
}

class _EmAndamentoPageState extends State<EmAndamentoPage> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Widget _textBuilder(IconData icon, String text) {
    return Row(children: [Icon(icon), Text(text)]);
  }

  String endDateFormated(DateTime dateTime) {
    var dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(dateTime);
  }

  Widget _createCards(Demanda demand) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed('/demand-info', arguments: demand),
        child: Container(
            child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: demand.urlImage,
              imageBuilder: (context, imageProvider) => Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill)),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(demand.name),
                    Divider(
                      height: 5,
                      thickness: 1,
                    ),
                    _textBuilder(Icons.calendar_today,
                        endDateFormated(demand.endDate.toDate())),
                    _textBuilder(Icons.folder, demand.categories.toString()),
                    _textBuilder(Icons.location_on, demand.localization),
                  ]),
            ),
            SizedBox(
              width: 10,
            )
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    return BlocProvider(
        create: (context) =>
            EmAndamentoBloc(userService: userService)..add(GetUserData()),
        child: BlocBuilder<EmAndamentoBloc, EmAndamentoState>(
            builder: (context, state) {
          if (state is EmAndamentoError) {
            return Center(child: Text("Error"));
          } else if (state is EmAndamentoInitial ||
              state is EmAndamentoLoading) {
            return Center(child: CustomCircularProgressIndicator());
          } else if (state is EmAndamentoLoaded) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Em Andamento",
                      style: TextStyle(fontSize: 30, color: Colors.black)),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  leading: null,
                  elevation: 0,
                ),
                extendBodyBehindAppBar: false,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: state.type == 'employer'
                    ? Container(
                        width: 150,
                        child: FloatingActionButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/nova-demanda');
                            },
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 15,
                                  ),
                                  Text("Nova demanda"),
                                ])),
                      )
                    : null,
                body: Container(
                  child: Center(
                      child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: state.demands.length,
                              itemBuilder: (context, index) {
                                return _createCards(state.demands[index]);
                              })),
                    ],
                  )),
                ));
          }
        }));
  }
}
