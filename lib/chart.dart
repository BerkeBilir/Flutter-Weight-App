import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:spring/spring.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Beden Kütle İndeks Grafiği'),
        ),
        body: _getGauge());
  }

  Widget _getGauge({bool isRadialGauge = true}) {
    num? height;
    num? weight;
    _fetch() async {
      final firebaseUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        height = ds['height'];
        weight = ds['weight'];
      }).catchError((e) {
        print(e);
      });
    }

    if (isRadialGauge) {
      return FutureBuilder(
          future: _fetch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                  child: Lottie.asset(
                'assets/images/98635-loading.json',
                width: 150,
                height: 150,
              ));
            }
            return SimpleBuilder(builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: BmiChart(height: height, weight: weight),
              );
            });
          });
    } else {
      return const Text('Boş');
    }
  }
}

class BmiChart extends StatelessWidget {
  BmiChart({
    Key? key,
    required this.height,
    required this.weight,
  }) : super(key: key);

  final num? height;
  final num? weight;
  num bmi = 0;
  String bmiResult = '';
  String bmiTitle = '';
  Color bmiColor = Colors.blue;

  String getInt(String bmiResult) {
    if ((bmi < 16)) {
      return 'Aşırı Düşük Kilolu'.tr;
    } else if ((bmi >= 16) && (bmi < 16.9)) {
      return 'Çok Düşük Kilolu'.tr;
    } else if ((bmi >= 17) && (bmi < 18.5)) {
      return 'Düşük Kilolu'.tr;
    } else if ((bmi >= 18.5) && (bmi < 25)) {
      return 'Normal'.tr;
    } else if (bmi >= 25 && bmi < 30) {
      return 'Fazla Kilolu'.tr;
    } else if (bmi >= 30 && bmi < 35) {
      return 'Şişman (Obez) - I. Sınıf'.tr;
    } else if (bmi >= 35 && bmi < 40) {
      return 'Şişman (Obez) - II. Sınıf'.tr;
    } else {
      return 'Aşırı Şişman (Aşırı Obez) - III. Sınıf'.tr;
    }
  }

  Color getColor(Color bmiColor) {
    if ((bmi < 16)) {
      return Colors.red;
    } else if ((bmi >= 16) && (bmi < 16.9)) {
      return const Color.fromARGB(255, 255, 230, 0);
    } else if ((bmi >= 17) && (bmi < 18.5)) {
      return const Color.fromARGB(255, 230, 216, 92);
    } else if ((bmi >= 18.5) && (bmi < 25)) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return const Color.fromARGB(255, 230, 216, 92);
    } else if (bmi >= 30 && bmi < 35) {
      return const Color.fromARGB(255, 255, 230, 0);
    } else if (bmi >= 35 && bmi < 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getTitle(String bmiTitle) {
    if (bmi < 18.5) {
      return 'getTitle1'.tr;
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'getTitle2'.tr;
    } else if (bmi >= 25 && bmi < 30) {
      return 'getTitle3'.tr;
    } else {
      return 'getTitle4'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    double calculateBmi(num height, num weight) {
      bmi = weight / pow(height / 100, 2.0);
      return bmi.toDouble();
    }

    String result = calculateBmi(height!, weight!).toStringAsFixed(1);
    String resultDetail = getInt(bmiResult);
    String resultTitle = getTitle(bmiTitle);
    Color resultColor = getColor(bmiColor);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 1500,
              title: const GaugeTitle(
                  text: '',
                  textStyle:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              axes: <RadialAxis>[
                RadialAxis(
                    canScaleToFit: true,
                    minimum: 10,
                    maximum: 40,
                    interval: 3,
                    startAngle: 180,
                    endAngle: 0,
                    majorTickStyle: const MajorTickStyle(
                        lengthUnit: GaugeSizeUnit.factor,
                        thickness: 1.3,
                        length: 0.1),
                    axisLabelStyle: const GaugeTextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    ranges: <GaugeRange>[
                      GaugeRange(
                          label: 'Aşırı Düşük',
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: 0,
                          endValue: 16,
                          color: Colors.red,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          startValue: 16,
                          endValue: 17,
                          color: Colors.orange,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          startValue: 17,
                          endValue: 18.5,
                          color: const Color.fromARGB(255, 255, 230, 0),
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          label: 'Normal',
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: 18.5,
                          endValue: 25,
                          color: Colors.green,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          label: 'Fazla Kilo',
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: 25,
                          endValue: 30,
                          color: const Color.fromARGB(255, 255, 230, 0),
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          label: 'Şişman-I',
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: 30,
                          endValue: 35,
                          color: Colors.orange,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          label: 'Şişman-II',
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: 35,
                          endValue: 40,
                          color: Colors.red,
                          startWidth: 25,
                          endWidth: 25),
                    ],
                    pointers: <GaugePointer>[
                      MarkerPointer(
                          value: calculateBmi(height!, weight!),
                          markerOffset: -32,
                          markerType: MarkerType.text,
                          text: 'BKİ',
                          textStyle: GaugeTextStyle(
                            fontSize: 15,
                            color: resultColor,
                            fontWeight: FontWeight.bold,
                          )),
                      MarkerPointer(
                        value: calculateBmi(height!, weight!),
                        markerHeight: 25,
                        markerWidth: 25,
                        elevation: 10,
                        color: Colors.white,
                        markerOffset: -10,
                      )
                    ])
              ]),
          Expanded(
            child: Spring.fadeIn(
              animDuration: const Duration(milliseconds: 1500),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: 
                    Column(children: [
                      Text(resultDetail,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Text(result.toString(),
                          style: TextStyle(
                              color: resultColor,
                              fontSize: 35,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      AutoSizeText(resultTitle,
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w500))
                    ]),
              )),
            ),
          )
        ],
      ),
    );
  }
}
