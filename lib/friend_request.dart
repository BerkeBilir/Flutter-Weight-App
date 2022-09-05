import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/bottom_nav_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({Key? key}) : super(key: key);

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  final firebaseUser = FirebaseAuth.instance.currentUser!;
  final box = GetStorage();

  dynamic dataTwo = Get.arguments;
  bool? infoSharePermissonDb;
  num? weightTarget;
  DateTime _dateNow = DateTime.now();
  DateTime _dateYestreday = DateTime.now().subtract(const Duration(days: 1));
  DateTime _dateLastWeek = DateTime.now().subtract(const Duration(days: 7));
  DateTime _dateLastMoon = DateTime.now().subtract(const Duration(days: 30));
  dynamic dailyWeightDb;
  dynamic yesterdayWeightDb;
  double? dailyChange;
  num? valueBmiDb;
  num? ageBmiDb;
  num? heightBmiDb;
  num? weightBmiDb;
  String? lastWeekDateDb;
  dynamic lastWeekWeightDb;
  String? lastMoonDateDb;
  dynamic lastMoonWeightDb;
  dynamic weightTargetDb;
  dynamic targetDailyDateDb;
  num bmi = 0;

      _fetch() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(dataTwo[0]['uid'])
        .get()
        .then((ds) {
      infoSharePermissonDb = ds['infoSharePermisson'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchOne() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(dataTwo[0]['uid'])
        .collection('targets')
        .doc(dataTwo[0]['uid'])
        .get()
        .then((ds) {
      weightTarget = ds['weightTarget'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchTwo() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateNow).toString())
        .get()
        .then((ds) {
      dailyWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchThree() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateYestreday).toString())
        .get()
        .then((ds) {
      yesterdayWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }
  _fetchFour() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateNow).toString())
        .get()
        .then((ds) {
      dailyWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateYestreday).toString())
        .get()
        .then((ds) {
      yesterdayWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchFive() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(dataTwo[0]['uid'])
        .get()
        .then((ds) {
      valueBmiDb = ds['gender'];
      ageBmiDb = ds['age'];
      heightBmiDb = ds['height'];
      weightBmiDb = ds['weight'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchSix() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateNow).toString())
        .get()
        .then((ds) {
      lastWeekWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateLastWeek).toString())
        .get()
        .then((ds) {
      lastWeekWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchSeven() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateNow).toString())
        .get()
        .then((ds) {
      lastMoonWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateLastMoon).toString())
        .get()
        .then((ds) {
      lastMoonWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchEight() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("targets")
        .doc(dataTwo[0]['uid'])
        .get()
        .then((ds) {
      weightTargetDb = ds['weightTarget'];
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(dataTwo[0]['uid'])
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateNow).toString())
        .get()
        .then((ds) {
      targetDailyDateDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    String calculateBmi(num heightBmiDb, num weightBmiDb) {
      bmi = weightBmiDb / pow(heightBmiDb / 100, 2.0);
      return bmi.toStringAsFixed(1);
    }

    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: Text('Arkadaşlar'.tr), actions: [
        IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Dikkat!',
                titleStyle: const TextStyle(color: Colors.red, fontSize: 24),
                titlePadding: const EdgeInsets.only(top: 10),
                content: Column(children: [
                  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: '${dataTwo[0]['name']} ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600, color: box.read('darkmode') == false ? Colors.black : Colors.white)),
                          TextSpan(
                              text: '${dataTwo[0]['surname']} ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600, color: box.read('darkmode') == false ? Colors.black : Colors.white)),
                          TextSpan(
                              text: 'isimli ve ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400, color: box.read('darkmode') == false ? Colors.black : Colors.white)),
                          TextSpan(
                              text: '${dataTwo[0]['uniqeKey']} ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600, color: box.read('darkmode') == false ? Colors.black : Colors.white)),
                          TextSpan(
                              text:
                                  'kullanıcı adlı kişiyi arkadaşlıktan çıkarmak istiyor musunuz?',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400, color: box.read('darkmode') == false ? Colors.black : Colors.white)),
                        ],
                      ),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const SizedBox(
                              width: double.infinity,
                              child: Card(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Center(
                                        child: Text('Vazgeç',
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight:
                                                    FontWeight.w600))),
                                  )))),
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(firebaseUser.uid)
                                .collection('friends')
                                .doc(dataTwo[0]['uid'])
                                .delete()
                                .then((value) {
                              Get.offAll(const BottomNavBarPage());
                            }).then((value) {
                              Get.snackbar(
                                '',
                                "",
                                titleText: const Text("İşlem Başarılı",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600)),
                                messageText: RichText(
                                    text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${dataTwo[0]['name']} ',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    TextSpan(
                                        text: '${dataTwo[0]['surname']} ',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    const TextSpan(
                                        text: 'isimli ve ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    TextSpan(
                                        text: '${dataTwo[0]['uniqeKey']} ',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    const TextSpan(
                                        text:
                                            'kullanıcı adlı kişiyi arkadaşlıktan çıkarıldı',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                )),
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 5),
                              );
                            });
                          },
                          child: const SizedBox(
                              width: double.infinity,
                              child: Card(
                                  color: Colors.red,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Center(
                                        child: Text('Çıkar',
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight:
                                                    FontWeight.w600))),
                                  )))),
                    ),
                  ])
                ]),
              );
            },
            icon: const Icon(Icons.more_vert))
      ]),
      body: FutureBuilder(
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
            return 
            infoSharePermissonDb == true ? Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Column(
                children: [
                  SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(dataTwo[0]['imageUrl']))),
                  const SizedBox(height: 25),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(dataTwo[0]['name'],
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 5),
                        Text(dataTwo[0]['surname'],
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500)),
                      ]),
                  const SizedBox(height: 10),
                  Opacity(
                    opacity: 0.7,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Kullanıcı Adı:',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  )),
                          const SizedBox(width: 5),
                          Text(dataTwo[0]['uniqeKey'],
                              style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  )),
                        ]),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  FutureBuilder(
                                      future: _fetchOne(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Center(
                                              child: Lottie.asset(
                                            'assets/images/98635-loading.json',
                                            width: 100,
                                            height: 100,
                                          ));
                                        }
                                        return SizedBox(
                                          width: width / 2.2,
                                          height: height / 8,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Color(0xFF285C71),
                                                  ),
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText('Hedef Kilo',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1,),
                                                      ),
                                                      weightTarget != null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AutoSizeText(
                                                                    weightTarget
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        fontWeight:
                                                                            FontWeight.w600),maxLines: 1),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText(
                                                                    'kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  const SizedBox(width: 10),
                                  FutureBuilder(
                                      future: _fetchTwo(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Center(
                                              child: Lottie.asset(
                                            'assets/images/98635-loading.json',
                                            width: 100,
                                            height: 100,
                                          ));
                                        }
                                        return SizedBox(
                                          width: width / 2.2,
                                          height: height / 8,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText(
                                                            'Bugünkü Kilo',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1),
                                                      ),
                                                      dailyWeightDb != null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AutoSizeText(
                                                                    dailyWeightDb
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        fontWeight:
                                                                            FontWeight.w600),maxLines: 1),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText(
                                                                    'kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Color(0xFF486A71),
                                                  ),
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  FutureBuilder(
                                      future: _fetchThree(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Center(
                                              child: Lottie.asset(
                                            'assets/images/98635-loading.json',
                                            width: 100,
                                            height: 100,
                                          ));
                                        }
                                        return SizedBox(
                                          width: width / 2.2,
                                          height: height / 8,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Color(0xFF486A71),
                                                  ),
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText('Dünkü Kilo',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1),
                                                      ),
                                                      yesterdayWeightDb !=
                                                              null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AutoSizeText(
                                                                    yesterdayWeightDb
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        fontWeight:
                                                                            FontWeight.w600),maxLines: 1),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText(
                                                                    'kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  const SizedBox(width: 10),
                                  FutureBuilder(
                                      future: _fetchFour(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Center(
                                              child: Lottie.asset(
                                            'assets/images/98635-loading.json',
                                            width: 100,
                                            height: 100,
                                          ));
                                        }
                                        var a = yesterdayWeightDb != null
                                            ? dailyWeightDb != null
                                                ? dailyWeightDb -
                                                    yesterdayWeightDb
                                                : 0
                                            : 0;
                                        return SizedBox(
                                          width: width / 2.2,
                                          height: height / 8,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText('Günlük Değişim',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1),
                                                      ),
                                                      yesterdayWeightDb !=
                                                              null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                a != null
                                                                    ? AutoSizeText(
                                                                        a.toStringAsFixed(
                                                                            1),
                                                                        style: const TextStyle(
                                                                            fontSize: 30,
                                                                            fontWeight: FontWeight.w600),maxLines: 1)
                                                                    : const Text('Boş'),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText('kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Color(0xFF285C71),
                                                  ),
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width / 2.2,
                                    height: height / 8,
                                    child: FutureBuilder(
                                        future: _fetchFive(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState !=
                                              ConnectionState.done) {
                                            return Center(
                                                child: Lottie.asset(
                                              'assets/images/98635-loading.json',
                                              width: 100,
                                              height: 100,
                                            ));
                                          }
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Color(0xFF285C71),
                                                  ),
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText('BKİ',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1),
                                                      ),
                                                      yesterdayWeightDb !=
                                                              null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AutoSizeText(
                                                                    calculateBmi(heightBmiDb!,
                                                                            weightBmiDb!)
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        fontWeight:
                                                                            FontWeight.w600),maxLines: 1),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText(
                                                                    'kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: width / 2.2,
                                    height: height / 8,
                                    child: FutureBuilder(
                                        future: _fetchEight(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState !=
                                              ConnectionState.done) {
                                            return Center(
                                                child: Lottie.asset(
                                              'assets/images/98635-loading.json',
                                              width: 100,
                                              height: 100,
                                            ));
                                          }
                                          var b = weightTargetDb != null
                                            ? targetDailyDateDb != null
                                                ? targetDailyDateDb -
                                                    weightTargetDb
                                                : 0
                                            : 0;
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText('Hedefe Kalan',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1),
                                                      ),
                                                      weightTargetDb !=
                                                              null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AutoSizeText(
                                                                    b.abs()
                                                                        .toStringAsFixed(1),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        fontWeight:
                                                                            FontWeight.w600),maxLines: 1),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText(
                                                                    'kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            color: Color(0xFF486A71),
                                                          ),
                                                          width: 15,
                                                        ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(children: [
                                SizedBox(
                                  width: width / 2.2,
                                  height: height / 8,
                                  child: FutureBuilder(
                                      future: _fetchSix(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Center(
                                              child: Lottie.asset(
                                            'assets/images/98635-loading.json',
                                            width: 100,
                                            height: 100,
                                          ));
                                        }
                                        var lastWeek =
                                            lastWeekWeightDb != null
                                                ? dailyWeightDb != null
                                                    ? dailyWeightDb -
                                                        lastWeekWeightDb
                                                    : 0
                                                : 0;
                                        return SizedBox(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Color(0xFF486A71),
                                                  ),
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText('Haftalık Değişim',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1),
                                                      ),
                                                      lastWeekWeightDb != null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                lastWeek !=
                                                                        null
                                                                    ? AutoSizeText(
                                                                        lastWeek.toStringAsFixed(
                                                                            1),
                                                                        style: const TextStyle(
                                                                            fontSize: 30,
                                                                            fontWeight: FontWeight.w600),maxLines: 1)
                                                                    : const Text('Boş'),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText('kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: width / 2.2,
                                  height: height / 8,
                                  child: FutureBuilder(
                                      future: _fetchSeven(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Center(
                                              child: Lottie.asset(
                                            'assets/images/98635-loading.json',
                                            width: 100,
                                            height: 100,
                                          ));
                                        }
                                        var a = lastMoonWeightDb != null
                                            ? dailyWeightDb != null
                                                ? lastMoonWeightDb -
                                                    dailyWeightDb
                                                : 0
                                            : 0;
                                        return SizedBox(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: AutoSizeText('Aylık Değişim',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,maxLines: 1),
                                                      ),
                                                      lastMoonWeightDb != null
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                a != null
                                                                    ? AutoSizeText(
                                                                        a.toStringAsFixed(
                                                                            1),
                                                                        style: const TextStyle(
                                                                            fontSize: 30,
                                                                            fontWeight: FontWeight.w600),maxLines: 1)
                                                                    : const Text('Boş'),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const AutoSizeText('kg',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.w500),maxLines: 1)
                                                              ],
                                                            )
                                                          : const AutoSizeText(
                                                              '(Girilmedi)',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),maxLines: 1)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Color(0xFF285C71),
                                                  ),
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ]),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ) : Center(
              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Card(
                                      child: SizedBox(
                                    width: width / 0.5,
                                    height: height / 5.25,
                                    child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                                          child: AutoSizeText(
                                      'Kullanıcı kendi bilgilerini paylaşmak istemiyor.',
                                      style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center, maxLines:2
                                    ),
                                        )),
                                  )),
                                ),
            );
          }),
    );
  }
}
