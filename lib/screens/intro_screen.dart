import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/screens/login_screen.dart';

class IntroScreen extends BaseRoute {
  IntroScreen(
      {super.analytics, super.observer, super.routeName = 'IntroScreen'});
  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends BaseRouteState {
  int _currentIndex = 0;
  PageController? _pageController;

  List<Map<String, String>> data = [
    {
      "title": "From Farm to\nYour Doorstep",
      "subtitle": "Experience the freshness of\nlocal produce delivered\nevery morning."
    },
    {
      "title": "Your Choice,\nYour Schedule",
      "subtitle": "Flexible subscriptions or\none-time purchases — just\nhow you want it."
    },
    {
      "title": "Delivered Daily\nBefore You Wake Up",
      "subtitle": "Early morning doorstep\ndeliveries across your\nneighborhood."
    },
    {
      "title": "Fresh. Local.\nHonest.",
      "subtitle": "We partner with local\nfarmers to bring you\npesticide-free freshness."
    },
  ];

  _IntroScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorConstants.beige,
          body: Stack(children: [
        Container(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _currentIndex = index;
              setState(() {});
            },
            children: [
              ...List.generate(
                4,
                (index) => SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        data[index]['title']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstants.brown,
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        data[index]['subtitle']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstants.brown,
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.65
                        ),
                        child: Image.asset(
                          width: double.infinity,
                            'assets/images/intro_${index + 1}_overlay.png',
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 25),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 15, top: 20),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < 4; i++)
                              if (i == _currentIndex) ...[circleBar(true)] else
                                circleBar(false),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.90,
          right: 0,
          left: 0,
          child: Align(
            alignment: Alignment.center,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                if (_currentIndex < 3) {
                  _pageController!.animateToPage(_currentIndex + 1,
                      duration: Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn);
                } else {
                  Get.to(() => LoginScreen(
                        analytics: widget.analytics,
                        observer: widget.observer,
                      ));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.brown,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.80,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _currentIndex < 3 ? 'Next' : 'Get Started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ])),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 5 : 5,
      width: isActive ? 23 : 10,
      decoration: BoxDecoration(
          color: isActive
              ? ColorConstants.brown
              : ColorConstants.brown.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _pageController!.addListener(() {});
  }
}
