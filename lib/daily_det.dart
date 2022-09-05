import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'daily_weight.dart';
import 'person_info_daily_weight.dart';

class DailyDetPage extends StatefulWidget {
  const DailyDetPage({Key? key}) : super(key: key);

  @override
  State<DailyDetPage> createState() => _DailyDetPageState();
}

class _DailyDetPageState extends State<DailyDetPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Günlük Kilo Takibi'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
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
                            color: Color(0xFF285C71)
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
                                        fontWeight: FontWeight.w500), textAlign:
                                                      TextAlign.center, maxLines:1),
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
                            color: Colors.teal,
                            ),
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: AutoSizeText('Günlük Kilo Geçmişi',
                                      style: TextStyle(
                                          fontSize: 17, fontWeight: FontWeight.w500), textAlign:
                                                        TextAlign.center, maxLines:1),
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
          ],
        ),
      ),
    );
  }
}
