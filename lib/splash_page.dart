import 'dart:async';
import 'package:flag_app/controllers/country_controller.dart';
import 'package:flag_app/controllers/hint_controller.dart';
import 'package:flag_app/controllers/level_controller.dart';
import 'package:flag_app/controllers/score_controller.dart';
import 'package:get/get.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'controllers/country_continent_controller.dart';
import 'helper/dimensions.dart';
import 'helper/route_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SpalshPageState();
}

class _SpalshPageState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
    await Get.find<CountryController>().readCountries();
    await Get.find<CountryContinentController>().readCountries();
    await Get.find<ScoreController>().readAllScores();
    await Get.find<HintController>().readHints();
    await Get.find<LevelController>().readAllLevels();
  }

  @override
  void initState() {
    super.initState();
    //TODO: ADD timer to match end of load
    _loadResource();
    /*.then((value) {
      Get.offNamed(RouteHelper.getInitial());
      dispose();
    });*/
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    Timer(Duration(seconds: 3, milliseconds: 300),
        () => Get.offNamed(RouteHelper.getInitial()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Image.asset(
                'assets/image/flags.png',
                width: Dimensions.splashImg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
