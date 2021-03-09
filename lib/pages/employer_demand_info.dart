import 'package:aplicai/components/custom_circular_progress_indicator.dart';
import 'package:aplicai/entity/demanda.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployerDemandInfo extends StatelessWidget {
  Demanda demanda;

  EmployerDemandInfo({this.demanda});

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
          Text("Title"),
          Divider(color: Colors.black),
          _textBuilder(Icons.work, demanda.name),
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
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    _createTop(),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(height: 15),
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
                  ]))),
    );
  }
}
