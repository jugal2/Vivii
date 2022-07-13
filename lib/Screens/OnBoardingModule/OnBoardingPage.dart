import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:introduction_slider/introduction_slider.dart';
import 'package:vivii/Screens/AuthenticationModule/LoginPage.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionSlider(
        isScrollable: true,
        selectedDotColor: Colors.transparent,
        unselectedDotColor: Colors.transparent,
        onDone: LoginPage(),
        done: Container(
          margin: EdgeInsets.only(left: 30),
          decoration: BoxDecoration(
              color: HexColor("8bcac1"),
              borderRadius: BorderRadius.circular(10)),
          height: 40,
          width: 80,
          child: Center(
              child: Text(
            "Login",
            style: GoogleFonts.nunito(fontSize: 15, color: Colors.black),
          )),
        ),
        next: Container(
          margin: EdgeInsets.only(left: 30),
          decoration: BoxDecoration(
              color: HexColor("8bcac1"),
              borderRadius: BorderRadius.circular(10)),
          height: 40,
          width: 80,
          child: Center(
              child: Text(
            "Next",
            style: GoogleFonts.nunito(fontSize: 15, color: Colors.black),
          )),
        ),
        showSkipButton: true,
        skip: Text(
          "Skip Now",
          style: GoogleFonts.nunito(color: Colors.grey.shade500, fontSize: 16),
        ),
        items: [
          IntroductionSliderItem(
            image: FlutterLogo(),
            title: "Introduction Slider 1",
            description: "This is a description of introduction slider 1.",
          ),
          IntroductionSliderItem(
            image: FlutterLogo(),
            title: "Introduction Slider 2",
            description: "This is a description of introduction slider 2.",
          ),
          IntroductionSliderItem(
            image: FlutterLogo(),
            title: "Introduction Slider 3",
            description: "This is a description of introduction slider 3.",
          ),
        ],
      ),
    );
  }
}
