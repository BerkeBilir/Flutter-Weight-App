import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/screens/mainscreen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final onBoarding = GetStorage();

  void _onIntroEnd(context) {
    onBoarding.write('onBoardingScreen', 1);
    Get.offAll(MainScreen());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Hoşgeldiniz",
          body:
          "Uygulamayı Tanımaya başlayınız.",
          image: Lottie.asset('assets/images/30173-welcome-screen.json'),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          reverse: true,
        ),
        PageViewModel(
          title: "Kilo ve Vücut Sağlığı Takibi",
          body:
          "Düzenli şekilde kilo bilgilerinizi girerek vücudunuzun sağlığını takip edebilirsiniz.",
          image: Lottie.asset('assets/images/105651-weight-scale.json', height: height/2.5),
          decoration: pageDecoration.copyWith(
            bodyFlex: 3,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.bottomCenter,
          ),
          reverse: true,
        ),
        PageViewModel(
          title: "Arkadaşlarını Takip et",
          body:
          "Arkadaşlarını takip ederek onların kilo bilgilerini görebilir ve kendi bilgilerinle kıyaslayabilirsin.",
          image: Lottie.asset('assets/images/113973-share.json'),
          decoration: pageDecoration.copyWith(
            bodyFlex: 3,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Geç', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Bitti', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}