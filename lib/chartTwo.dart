import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/simple_builder.dart';
import 'package:lottie/lottie.dart';
import 'package:spring/spring.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChartTwoPage extends StatefulWidget {
  const ChartTwoPage({Key? key}) : super(key: key);

  @override
  State<ChartTwoPage> createState() => _ChartTwoPageState();
}

class _ChartTwoPageState extends State<ChartTwoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('İdeal Kilo Grafiği'),
        ),
        body: _getGauge());
  }

  Widget _getGauge({bool isRadialGauge = true}) {
    num? height;
    num? weight;
    num? value;
    _fetch() async {
      final firebaseUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        height = ds['height'];
        weight = ds['weight'];
        value = ds['gender'];
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
                child:
                    IdealWeight(height: height, weight: weight, value: value),
              );
            });
          });
    } else {
      return const Text('Boş');
    }
  }
}

class IdealWeight extends StatelessWidget {
  const IdealWeight({
    Key? key,
    required this.height,
    required this.weight,
    required this.value,
  }) : super(key: key);

  final num? height;
  final num? weight;
  final num? value;

  @override
  Widget build(BuildContext context) {
    num calHeightMale = 0;
    num calHeightFemale = 0;
    double calculateWeightMale(num height) {
      calHeightMale = (height - 152) * 0.9 + 50;
      return calHeightMale.toDouble();
    }

    double calculateWeightFemale(num height) {
      calHeightFemale = (height - 152) * 0.9 + 45.5;
      return calHeightFemale.toDouble();
    }

    var sonuc = value == 0
        ? calculateWeightMale(height!) - weight!
        : calculateWeightFemale(height!) - weight!;

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
                    minimum: value == 0
                        ? calculateWeightMale(height!) - 5
                        : calculateWeightFemale(height!) - 5,
                    maximum: value == 0
                        ? calculateWeightMale(height!) + 5
                        : calculateWeightFemale(height!) + 5,
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
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: value == 0
                              ? calculateWeightMale(height!) - 5
                              : calculateWeightFemale(height!) - 5,
                          endValue: value == 0
                              ? calculateWeightMale(height!) - 3
                              : calculateWeightFemale(height!) - 3,
                          color: Colors.red,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          startValue: value == 0
                              ? calculateWeightMale(height!) - 3
                              : calculateWeightFemale(height!) - 3,
                          endValue: value == 0
                              ? calculateWeightMale(height!) - 1.5
                              : calculateWeightFemale(height!) - 1.5,
                          color: Colors.orange,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          startValue: value == 0
                              ? calculateWeightMale(height!) - 1.5
                              : calculateWeightFemale(height!) - 1.5,
                          endValue: value == 0
                              ? calculateWeightMale(height!) + 1.5
                              : calculateWeightFemale(height!) + 1.5,
                          color: Colors.green,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: value == 0
                              ? calculateWeightMale(height!) + 1.5
                              : calculateWeightFemale(height!) + 1.5,
                          endValue: value == 0
                              ? calculateWeightMale(height!) + 3
                              : calculateWeightFemale(height!) + 3,
                          color: Colors.orange,
                          startWidth: 25,
                          endWidth: 25),
                      GaugeRange(
                          labelStyle: const GaugeTextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          startValue: value == 0
                              ? calculateWeightMale(height!) + 3
                              : calculateWeightFemale(height!) + 3,
                          endValue: value == 0
                              ? calculateWeightMale(height!) + 5
                              : calculateWeightFemale(height!) + 5,
                          color: Colors.red,
                          startWidth: 25,
                          endWidth: 25),
                    ],
                    pointers: <GaugePointer>[
                      MarkerPointer(
                          value: value == 0
                              ? calculateWeightMale(height!)
                              : calculateWeightFemale(height!),
                          markerOffset: value == 0
                              ? calculateWeightMale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightMale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -70
                                      : -18
                                  : -18
                              : calculateWeightFemale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightFemale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -70
                                      : -18
                                  : -18,
                          markerType: MarkerType.text,
                          text: 'İdeal Kilonuz',
                          textStyle: const GaugeTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      MarkerPointer(
                          value: value == 0
                              ? calculateWeightMale(height!)
                              : calculateWeightFemale(height!),
                          markerHeight: value == 0
                              ? calculateWeightMale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightMale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? 60
                                      : 20
                                  : 20
                              : calculateWeightFemale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightFemale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? 60
                                      : 20
                                  : 20,
                          markerWidth: value == 0
                              ? calculateWeightMale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightMale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? 22
                                      : 20
                                  : 20
                              : calculateWeightFemale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightFemale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? 22
                                      : 20
                                  : 20,
                          elevation: 4,
                          markerOffset: value == 0
                              ? calculateWeightMale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightMale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -30
                                      : 0
                                  : 0
                              : calculateWeightFemale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightFemale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -30
                                      : 0
                                  : 0),
                      MarkerPointer(
                          value: weight!.toDouble(),
                          markerOffset: value == 0
                              ? calculateWeightMale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightMale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -30
                                      : -18
                                  : -18
                              : calculateWeightFemale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightFemale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -30
                                      : -18
                                  : -18,
                          markerType: MarkerType.text,
                          text: 'Kilonuz',
                          textStyle: const GaugeTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      MarkerPointer(
                          value: weight!.toDouble(),
                          markerHeight: 20,
                          markerWidth: 20,
                          elevation: 4,
                          markerOffset: value == 0
                              ? calculateWeightMale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightMale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -12
                                      : 0
                                  : 0
                              : calculateWeightFemale(height!) + 1.2 >=
                                      weight!.toDouble()
                                  ? calculateWeightFemale(height!) - 1.2 <=
                                          weight!.toDouble()
                                      ? -12
                                      : 0
                                  : 0)
                    ]),
              ]),
          Spring.fadeIn(
            animDuration: const Duration(milliseconds: 1500),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('İdeal Kilo Detayları',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 25),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Kilonuz:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                        Text("${weight!.toString()} kg",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("İdeal Kilonuz:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                        value == 0
                            ? Text(
                                "${calculateWeightMale(height!).toString()} kg",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                            : Text(
                                "${calculateWeightFemale(height!).toString()} kg",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        sonuc > 0
                            ? const Text("Almanız Gereken Kilo:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                            : const Text("Vermeniz Gereken Kilo",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                        Text("${sonuc.abs().toStringAsFixed(1)} kg",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ]),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
