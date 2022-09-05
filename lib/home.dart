import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bl.dart';
import 'body_det.dart';
import 'd.dart';
import 'daily_weight.dart';
import 'friend_list.dart';
import 'info.dart';
import 'person_info_daily_weight.dart';
import 'result.dart';
import 'settings.dart';
import 'target_det.dart';
import 'target_weight_info.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ana Sayfa'.tr),
      ),
      body: TopNav(),
      drawer: DrawerMenu(),
    );
  }
  Drawer DrawerMenu() {
    final box = GetStorage();
    return Drawer(
      child: Column(
        children: [
          Flexible(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  tileColor: box.read('darkmode') == false
                      ? const Color(0xFF1F3339)
                      : const Color(0xFF141616),
                  title: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                        child: Text('Menu'.tr,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white))),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      title: Text('Vücut Bilgileri'.tr,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Get.to(BodyDetPage());
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      title: Text('Arkadaşlar'.tr,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Get.to(const FriendListPage());
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      title: Text('Arkadaş Ekle'.tr,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Get.to(const CloudFirestoreSearch());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: GestureDetector(
              onTap: () {
                Get.to(const SettingsPage());
              },
              child: Card(
                color: const Color(0xFF486A71),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                        child: Text('Ayarlar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white))),
                  )),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}




class TopNav extends StatelessWidget {
  TopNav({super.key});

  @override
  final DateTime _dateNow = DateTime.now();

  final DateTime _dateYestreday =
      DateTime.now().subtract(const Duration(days: 1));

  dynamic dailyWeightDb;
  dynamic yesterdayWeightDb;
  String? yesterdayDateDb;
  String? lastWeekDateDb;
  dynamic lastWeekWeightDb;
  dynamic lastWeekWeighTwotDb;
  String? lastMoonDateDb;
  dynamic lastMoonWeightDb;
  String? nameDb;

  _fetchOne() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((ds) {
      nameDb = ds['name'];
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateNow).toString())
        .get()
        .then((ds) {
      dailyWeightDb = ds['dailyWeight'];
      print(dailyWeightDb);
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateYestreday).toString())
        .get()
        .then((ds) {
      yesterdayWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 6.0),
          child: SizedBox(
            height: 40,
            child: Column(children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Get.to(const DailyWeightPage());
                        // print(generatePassword());
                      },
                      child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                                child: Text('Günlük Kilo Girişi'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500))),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const PersoInfoDailyWeight());
                      },
                      child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                                child: Text('Günlük Kilo Geçmişi'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500))),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const InfoPage());
                      },
                      child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                                child: Text('Detaylı Vücut Bilgileri'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500))),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const ResultPage());
                      },
                      child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                                child: Text('Sonuçlarınız'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500))),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const TargetDet());
                      },
                      child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                                child: Text('Hedef Kilo Belirle'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500))),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const TargetWeightInfoPage());
                      },
                      child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                                child: Text('Hedef Detayları'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500))),
                          )),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
        FutureBuilder(
            future: _fetchOne(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Shimmer.fromColors(
                  baseColor: Color(0xFF486A71),
                  highlightColor: Color(0xFFAAB4BB),
                  child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 16),
                          child: Row(
                            children: [
                              Text('Merhaba'.tr,
                                  style: const TextStyle(
                                      fontSize: 26, fontWeight: FontWeight.w600)),
                                      SizedBox(width: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(60),
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(60)),
                                  ),
                          child: Container(
                            width: width / 1.4,
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AutoSizeText('Düne göre '.tr,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 1),
                                      AutoSizeText(' kilo verdin.'.tr,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
              ),
                );
              }
              var a = yesterdayWeightDb != null
                  ? dailyWeightDb != null
                      ? dailyWeightDb - yesterdayWeightDb
                      : 0
                  : 0;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 16),
                        child: Row(
                          children: [
                            Text('Merhaba'.tr,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600)),
                                    SizedBox(width: 4),
                                    Text('$nameDb',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(60),
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(60)),
                                ),
                        child: Container(
                          width: width / 1.4,
                          padding: const EdgeInsets.all(16.0),
                          child: dailyWeightDb != null
                              ? yesterdayWeightDb != null ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText('Düne göre '.tr,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1),
                                    AutoSizeText(a.abs().toStringAsFixed(1),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1),
                                    a < 0
                                        ? AutoSizeText(' kilo verdin.'.tr,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1)
                                        : AutoSizeText(' kilo aldın.'.tr,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1),
                                  ],
                                ) : AutoSizeText('Dünkü kilo verileri girilmedi.'.tr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1) : AutoSizeText('Günlük veriler girilmedi.'.tr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
        const Expanded(child: Dd())
      ],
    );
  }
}





