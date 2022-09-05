import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chart.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chartTwo.dart';
import 'info.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  num bmi = 0;
  String result = "";
  String resultDetail = '';
  String resultTitle = '';
  Color color = Colors.blue;
  Color idealColor = Colors.blue;

  Color getColorBmi(num bmiColor) {
    if ((bmi < 16)) {
      return Colors.red;
    } else if ((bmi >= 16) && (bmi < 16.9)) {
      return const Color.fromARGB(255, 255, 230, 0);
    } else if ((bmi >= 17) && (bmi < 18.5)) {
      return Colors.orange;
    } else if ((bmi >= 18.5) && (bmi < 25)) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return const Color.fromARGB(255, 230, 216, 92);
    } else if (bmi >= 30 && bmi < 35) {
      return Colors.orange;
    } else if (bmi >= 35 && bmi < 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  num newHeightMale = 0;
  num newHeightFemale = 0;

  num bloodVolMale = 0;
  num bloodVolFemale = 0;

  num calHeightMale = 0;
  num calHeightFemale = 0;

  num dayCalMale = 0;
  num dayCalFemale = 0;
  num surface = 0;

  num leanMale = 0;
  num leanFemale = 0;

  num allWeiMale = 0;
  num allWeiFemale = 0;

  num? value;
  num? age;
  num? height;
  num? weight;

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      value = ds['gender'];
      age = ds['age'];
      height = ds['height'];
      weight = ds['weight'];
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            String calculateBmi(num height, num weight) {
              bmi = weight / pow(height / 100, 2.0);
              return bmi.toStringAsFixed(1);
            }

            String calculateBloodMale(num height, num weight) {
              newHeightMale = height / 100;
              bloodVolMale = ((0.3669 * pow(newHeightMale, 3)) +
                      (0.03219 * weight) +
                      0.6041) *
                  1000;
              return bloodVolMale.toStringAsFixed(1);
            }

            String calculateBloodFemale(num height, num weight) {
              newHeightFemale = height / 100;
              bloodVolFemale = ((0.3561 * pow(newHeightFemale, 3)) +
                      (0.3308 * weight) +
                      0.1833) *
                  1000;
              return bloodVolFemale.toStringAsFixed(1);
            }

            String dayCalorieMale(num height, num weight, num age) {
              dayCalMale = 66 + (13.7 * weight) + (5 * height) - (6.8 * age);
              return dayCalMale.toStringAsFixed(1);
            }

            String dayCalorieFemale(num height, num weight, num age) {
              dayCalFemale =
                  655 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
              return dayCalFemale.toStringAsFixed(1);
            }

            Color getColorideal(num idealColor) {
              if ((weight! <= calHeightMale + 1.5 && weight! >= calHeightMale - 1.5)) {
                return Colors.green;
              } else if ((weight! <= calHeightMale + 3 && weight! >= calHeightMale - 3)) {
                return Colors.orange;
              } else {
                return Colors.red;
              }
            }

            String calculateWeightMale(num height) {
              calHeightMale = (height - 152) * 0.9 + 50;
              return calHeightMale.toStringAsFixed(1);
            }

            String calculateWeightFemale(num height) {
              calHeightFemale = (height - 152) * 0.9 + 45.5;
              return calHeightFemale.toStringAsFixed(1);
            }

            String calSurface(num height, num weight) {
              num newHe = height / 100;
              surface = 0.20247 * pow(newHe, 0.725) * pow(weight, 0.425);
              return surface.toStringAsFixed(1);
            }

            String calLeanMale(num height, num weight) {
              num newHe = height / 100;
              leanMale =
                  1.1 * weight - 128 * (pow(weight, 2) / pow((100 * newHe), 2));
              return leanMale.toStringAsFixed(1);
            }

            String calLeanFemale(num height, num weight) {
              num newHe = height / 100;
              leanFemale = 1.07 * weight -
                  148 * (pow(weight, 2) / pow((100 * newHe), 2));
              return leanFemale.toStringAsFixed(1);
            }

            String calAllWeiMale(num height, num weight) {
              num newAllWei = height / 100;
              allWeiMale = weight -
                  (1.1 * weight -
                      128 * (pow(weight, 2) / pow((100 * newAllWei), 2)));
              return allWeiMale.toStringAsFixed(1);
            }

            String calAllWeiFemale(num height, num weight) {
              num newAllWei = height / 100;
              allWeiFemale = weight -
                  (1.07 * weight -
                      148 * (pow(weight, 2) / pow((100 * newAllWei), 2)));
              return allWeiFemale.toStringAsFixed(1);
            }

            return Scaffold(
              appBar: AppBar(
            centerTitle: true,
            title: Text('Sonuçlar'.tr),
              ),
              body: weight != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, num index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(const ChartPage());
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('BKİ'.tr),
                                              const SizedBox(width: 2),
                                              const Text('(kg/m^2)')
                                            ],
                                          ),
                                          height != null
                                              ? Text(
                                                  calculateBmi(
                                                          height!, weight!)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color:
                                                          getColorBmi(bmi),
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : const Text('Boş')
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 34,
                                      right: 10,
                                      child: IconButton(
                                          icon: const FaIcon(
                                              FontAwesomeIcons.chartColumn),
                                          onPressed: () {
                                            Get.to(const ChartPage());
                                          }))
                                ],
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, num index) {
                            return GestureDetector(
                              onTap: () {Get.to(const ChartTwoPage());},
                              child: Stack(
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('İdeal Kilo'.tr),
                                              const SizedBox(width: 2),
                                              const Text('(kg)')
                                            ],
                                          ),
                                          value != null
                                              ? value == 0
                                                  ? Text(
                                                      calculateWeightMale(
                                                        height!,
                                                      ).toString(),
                                                      style: TextStyle(
                                                        color: getColorideal(calHeightMale),
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                  : Text(
                                                      calculateWeightFemale(
                                                        height!,
                                                      ).toString(),
                                                      style: TextStyle(
                                                        color: getColorideal(calHeightFemale),
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.w600))
                                              : const Text('Boş'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 34,
                                      right: 10,
                                      child: IconButton(
                                          icon: const FaIcon(
                                              FontAwesomeIcons.chartColumn),
                                          onPressed: () {
                                            Get.to(const ChartTwoPage());
                                          }))
                                ],
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, num index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Yağsız Vücut Ağırlığı'.tr),
                                          const SizedBox(width: 2),
                                          const Text('(kg)')
                                        ],
                                      ),
                                      value != null
                                          ? value == 0
                                              ? Text(
                                                  calLeanMale(
                                                    height!,
                                                    weight!,
                                                  ).toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : Text(
                                                  calLeanFemale(
                                                    height!,
                                                    weight!,
                                                  ).toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                          : const Text('Boş'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, num index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Vücut Yağ Ağırlığı'.tr),
                                          const SizedBox(width: 2),
                                          const Text('(kg)')
                                        ],
                                      ),
                                      value != null
                                          ? value == 0
                                              ? Text(
                                                  calAllWeiMale(
                                                    height!,
                                                    weight!,
                                                  ).toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : Text(
                                                  calAllWeiFemale(
                                                    height!,
                                                    weight!,
                                                  ).toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                          : const Text('Boş'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, num index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Yüzey Alanı'.tr),
                                          const SizedBox(width: 2),
                                          const Text('(m^2)')
                                        ],
                                      ),
                                      weight != null
                                          ? Text(
                                              calSurface(
                                                height!,
                                                weight!,
                                              ).toString(),
                                              style: const TextStyle(
                                                  fontSize: 35,
                                                  fontWeight:
                                                      FontWeight.w600))
                                          : const Text('Boş'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, num index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Bazal Metabolizma'.tr),
                                          const SizedBox(width: 2),
                                          Text('(kcal/gün)'.tr)
                                        ],
                                      ),
                                      value != null
                                          ? value == 0
                                              ? Text(
                                                  dayCalorieMale(
                                                    height!,
                                                    weight!,
                                                    age!,
                                                  ).toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : Text(
                                                  dayCalorieFemale(
                                                    height!,
                                                    weight!,
                                                    age!,
                                                  ).toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                          : const Text('Boş'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, num index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Kan Volümü'.tr),
                                          const SizedBox(width: 2),
                                          const Text('(ml)')
                                        ],
                                      ),
                                      value != null
                                          ? value == 0
                                              ? Text(
                                                  calculateBloodMale(
                                                          height!, weight!)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : Text(
                                                  calculateBloodFemale(
                                                          height!, weight!)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600))
                                          : const Text('Boş'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                          child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        'Sonuçlarını görebilmek için detaylı hesaplama yapanız gerekiyor.'
                            .tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  )),
                  const SizedBox(height: 15),
                  ElevatedButton(onPressed: () {Get.to(const InfoPage());}, child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Detaylı hesaplama yap',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w500)),
                  ))
                    ],
                  ),
                ),
            );
          });
        });
  }
}
