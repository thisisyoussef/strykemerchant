import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:strykepay_merchant/screens/onboarding/components/onboard_page.dart';
import 'package:strykepay_merchant/screens/onboarding/intro_screen.dart';

class LaunchScreen extends StatefulWidget {
  static String id = "launch_screen";

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController launchController;
  Animation defaultAnimation;
  Animation launchAnimation;
  bool ready;
  void initState() {
    ready = false;
    super.initState();

    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 3), upperBound: 1);
    defaultAnimation =
        CurvedAnimation(parent: controller, curve: Curves.slowMiddle);
    launchAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInExpo);
    controller.forward();
    defaultAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
      print(launchAnimation.value);
      if (launchAnimation.value >= 1) {
        Navigator.pushNamed(context, "Insert Page ID");
        /* Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 700),
            transitionsBuilder: (context, animation, secAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.centerRight,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return IntroScreen();
            },
          ),
        );*/
      }
    });
    _checkInternetConnectivity();
  }

  @override
  build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Hero(
          tag: "logo",
          child: Image.asset(
            "assets/images/tamaslogo.png",
            height: !ready
                ? defaultAnimation.value * 250
                : launchAnimation.value * 500,
          ),
        ),
      ),
    );
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      print("connected to internet");
      ready = true;
    } else {
      setState(() {});
    }
  }
}
