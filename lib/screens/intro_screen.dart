import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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

  _IntroScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                6,
                (index) => Image.asset(
                  'assets/images/intro_${index + 1}.png',
                  fit: BoxFit.cover,
                  // color: Colors.black.withOpacity(0.2),
                  // colorBlendMode: BlendMode.darken,
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
                            for (int i = 0; i < 6; i++)
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
          right: MediaQuery.of(context).size.width / 3,
          bottom: 15,
          child: Align(
            alignment: Alignment.center,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                if (_currentIndex < 5) {
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
                      color: Color(0xff073100).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _currentIndex < 5 ? 'Next' : 'Get Started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffabff9d),
                        letterSpacing: 2.0,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_rounded,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  )
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
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
