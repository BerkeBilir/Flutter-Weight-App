import 'package:flutter/material.dart';
import 'package:flutter_hive/target_det.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'daily_weight.dart';
import 'info.dart';
import 'person_info_daily_weight.dart';
import 'result.dart';
import 'target_weight_info.dart';

class BodyDetPage extends StatefulWidget {
  const BodyDetPage({Key? key}) : super(key: key);

  @override
  State<BodyDetPage> createState() => _BodyDetPageState();
}

class _BodyDetPageState extends State<BodyDetPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Vücut Bilgileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(children: const <Widget>[
                Expanded(child: Divider(thickness: 1.5, color: Color(0xFF486A71))),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.0,
                  ),
                  child: Text("Günlük Kilo Takibi",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                ),
                Expanded(child: Divider(thickness: 1.5, color: Color(0xFF486A71))),
              ]),
            ),
            Row(children: [
              SizedBox(
                width: width / 2,
                height: height / 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              color: Color(0xFF285C71),
                            ),
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AutoSizeText('Günlük Kilo Girişi'.tr,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    maxLines: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.to(const DailyWeightPage());
                    },
                  ),
                ),
              ),
              SizedBox(
                width: width / 2,
                height: height / 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              color: Color(0xFF486A71),
                            ),
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: AutoSizeText('Günlük Kilo Geçmişi',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                      maxLines: 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.to(const PersoInfoDailyWeight());
                    },
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(children: const <Widget>[
                  Expanded(child: Divider(thickness: 1.5, color: Color(0xFF486A71))),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.0,
                    ),
                    child: Text("Detyalı Vücut Bilgileri",
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  ),
                  Expanded(child: Divider(thickness: 1.5, color: Color(0xFF486A71))),
                ]),
              ),
            ),
            Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(children: [
          Row(
            children: [
              SizedBox(
                width: width / 2,
                height: height / 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              color: Color(0xFF486A71),
                            ),
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('Detaylı Vücut Bilgileri',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.to(const InfoPage());
                    },
                  ),
                ),
              ),
              SizedBox(
                width: width / 2,
                height: height / 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              color: Color(0xFF285C71),
                            ),
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('Sonuçlarınız',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.to(const ResultPage());
                    },
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
      Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(children: const <Widget>[
                  Expanded(child: Divider(thickness: 1.5, color: Color(0xFF486A71))),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.0,
                    ),
                    child: Text("Hedef Kilo",
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  ),
                  Expanded(child: Divider(thickness: 1.5, color: Color(0xFF486A71))),
                ]),
              ),
            ),
            Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                width: width / 2,
                height: height / 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            color: Color(0xFF285C71),
                            ),
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Hedef Kilo Belirle'.tr,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.to(const TargetDet());
                    },
                  ),
                ),
              ),
              SizedBox(
                width: width / 2,
                height: height / 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            color: Color(0xFF486A71),
                            ),
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('Hedef Detayları',
                                    style: TextStyle(
                                        fontSize: 17, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.to(const TargetWeightInfoPage());
                    },
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}
