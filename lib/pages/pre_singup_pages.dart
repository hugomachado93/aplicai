import 'package:aplicai/enum/userTypeEnum.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class PreSignupPages extends StatefulWidget {
  PreSignupPages({this.userTypeEnum});

  final UserTypeEnum userTypeEnum;

  @override
  State<StatefulWidget> createState() {
    return PreSignupPagesState(userTypeEnum: userTypeEnum);
  }
}

class PreSignupPagesState extends State<PreSignupPages> {

  PreSignupPagesState({this.userTypeEnum});

  UserTypeEnum userTypeEnum;

  PageController _pageController = PageController(initialPage: 0);
  int _pageIndex = 0;

  @override
  Widget build(Object context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          width: 350,
          child: FloatingActionButton.extended(
            label: _pageIndex < 2
                ? Text(
                    "Continuar",
                    style: TextStyle(color: Colors.black),
                  )
                : Text("Cadastrar agora!",
                    style: TextStyle(color: Colors.black)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              if (_pageIndex >= 2) {
                var url = userTypeEnum == UserTypeEnum.student ? "/signup-student" : "/signup-employer";
                Navigator.of(context).pushNamed(url);
              }
              setState(() {
                _pageController.animateToPage(++_pageIndex,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.bounceInOut);
              });
            },
            backgroundColor: Colors.white,
          ),
        ),
        body: PageView(
          pageSnapping: true,
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          children: [
            Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Text("alo"),
                  SizedBox(
                    height: 300,
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: 0,
                    decorator: DotsDecorator(
                      color: Colors.black87,
                      activeColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Text("alo"),
                  SizedBox(
                    height: 300,
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: 1,
                    decorator: DotsDecorator(
                      color: Colors.black87,
                      activeColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  userTypeEnum == UserTypeEnum.student ? Text("estudante") : Text("empregador"),
                  SizedBox(
                    height: 300,
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: 2,
                    decorator: DotsDecorator(
                      color: Colors.black87,
                      activeColor: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
