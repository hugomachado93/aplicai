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
                var url = userTypeEnum == UserTypeEnum.student
                    ? "/signup-student"
                    : "/signup-employer";
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
                    height: 100,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: userTypeEnum == UserTypeEnum.student
                                ? AssetImage("assets/images/crie.png")
                                : AssetImage("assets/images/crie2.png"),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Crie seu perfil!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text("E seja parte da rede APLICAÍ!",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 250,
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
                    height: 100,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: userTypeEnum == UserTypeEnum.student
                                ? AssetImage("assets/images/ache.png")
                                : AssetImage("assets/images/encontre.png"),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  userTypeEnum == UserTypeEnum.student
                      ? Text(
                          "Encontre demandas!",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      : Text("Faça conexões!",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                  userTypeEnum == UserTypeEnum.student
                      ? Container(
                          width: 300,
                          child: Text(
                            "E veja onde suas habilidades podem ser colocadas em prática!",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Text(
                          "Entre em contato com estudantes que queiram pôr seus conhecimentos em prática!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                  SizedBox(
                    height: 250,
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
                    height: 150,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/aplique.png"),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  userTypeEnum == UserTypeEnum.student
                      ? Text(
                          "Aplique seu conhecimento!",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      : Text(
                          "Melhore seu empreendimento!",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                  userTypeEnum == UserTypeEnum.student
                      ? Text(
                          "E tenha ativamente uma experiência no mundo real!",
                          style: TextStyle(color: Colors.white),
                        )
                      : Container(
                          width: 300,
                          child: Text(
                            "Oferecendo oportunidade de experimentação ativa no mundo real!",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  SizedBox(
                    height: 150,
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
