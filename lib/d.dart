import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:d_chart/d_chart.dart';
import 'package:shimmer/shimmer.dart';
class Dd extends StatefulWidget {
  const Dd({Key? key}) : super(key: key);

  @override
  State<Dd> createState() => _DdState();
}

class _DdState extends State<Dd> {
  final firebaseUser = FirebaseAuth.instance.currentUser!;
  final box = GetStorage();

  final charts = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(7)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
                child: Container(
              height: height / 2.05,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                      child: Text('Haftalık Grafik'.tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      height: height / 2.4,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: StreamBuilder(
                              stream: charts,
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Hata');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                baseColor: Color(0xFF486A71),
                                highlightColor: Color(0xFFAAB4BB),child: Container(width: width, height: height, color:Colors.red));
                                }
                                List listChart = snapshot.data!.docs.map((e) {
                                  return {
                                    'domain': e.data()['dailyDate'],
                                    'measure': e.data()['dailyWeight'],
                                  };
                                }).toList();
                                List listValue = snapshot.data!.docs.map((e) {
                                  return {
                                    'barValue': e.data()['dailyWeight'],
                                  };
                                }).toList();
                                print(listValue.length);
                                return Container(
                                  width: listValue.length <= 3
                                      ? width
                                      : listValue.length <= 4
                                          ? width * 1.2
                                          : listValue.length <= 5
                                              ? width * 1.5
                                              : listValue.length <= 6
                                                  ? width * 1.9
                                                  : listValue.length <= 7
                                                      ? width * 2.2
                                                      : width * 2.2,
                                  child: DChartBar(
                                    data: [
                                      {
                                        'id': 'Bar',
                                        'data': listChart,
                                      },
                                    ],
                                    domainLabelPaddingToAxisLine: 16,
                                    axisLineTick: 2,
                                    axisLinePointTick: 2,
                                    animate: true,
                                    animationDuration: Duration(milliseconds: 500),
                                    axisLinePointWidth: 0,
                                    measureLabelPaddingToAxisLine: 10,
                                    showBarValue: true,
                                    barValue: (barData, index) =>
                                        '${barData['measure']} \nkg',
                                    domainLabelFontSize: 17,
                                    barValueFontSize: 19,
                                    barValueAnchor: BarValueAnchor.middle,
                                    barValueColor: box.read('darkmode') == false
                                            ? Colors.black
                                            : Colors.white,
                                    barColor: (barData, index, id) => Color(0xFF486A71),
                      axisLineColor: Color(0xFF486A71),
                                    measureLabelColor:
                                        box.read('darkmode') == false
                                            ? Colors.black
                                            : Colors.white,
                                    domainLabelColor:
                                        box.read('darkmode') == false
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            )),
          ],
        ),
      ),
    );
  }
}
