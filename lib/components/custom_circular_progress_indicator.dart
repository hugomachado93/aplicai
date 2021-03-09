import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  double size;
  CustomCircularProgressIndicator({this.size = 100});

  @override
  Widget build(Object context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
