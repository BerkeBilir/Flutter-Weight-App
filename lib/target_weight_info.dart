import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';

class TargetWeightInfoPage extends StatefulWidget {
  const TargetWeightInfoPage({Key? key}) : super(key: key);

  @override
  State<TargetWeightInfoPage> createState() => _TargetWeightInfoPage();
}

class _TargetWeightInfoPage extends State<TargetWeightInfoPage> {
  num? weightTarget;

  final DateTime _selectedDate = DateTime.now();

  num counter = 0;
  num counterTwo = 0;
  List bolmeList = [];
  List dailyChangeList = [];
  List dailyChangeListTwo = [];

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('targets')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      weightTarget = ds['weightTarget'];
    }).catchError((e) {
      print(e);
    });
  }

  final DateTime _dateNow = DateTime.now();
  final DateTime _dateYestreday = DateTime.now().subtract(const Duration(days: 1));
  final DateTime _dateLastWeek = DateTime.now().subtract(const Duration(days: 7));
  final DateTime _dateLastMoon = DateTime.now().subtract(const Duration(days: 30));
  dynamic dailyWeightDb;
  dynamic yesterdayWeightDb;
  String? yesterdayDateDb;
  String? lastWeekDateDb;
  dynamic lastWeekWeightDb;
  String? lastMoonDateDb;
  dynamic lastMoonWeightDb;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .snapshots();

  final Stream<QuerySnapshot> _startWeight = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .limit(1)
      .snapshots();


  _fetchOne() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
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

  _fetchTwo() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateYestreday).toString())
        .get()
        .then((ds) {
      yesterdayDateDb = ds['dailyDate'];
      yesterdayWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchThree() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
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
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateLastWeek).toString())
        .get()
        .then((ds) {
      lastWeekWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  _fetchFour() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
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
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("dailyInfo")
        .doc(DateFormat('dd-MM-yyyy').format(_dateLastMoon).toString())
        .get()
        .then((ds) {
      lastMoonWeightDb = ds['dailyWeight'];
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Hedef Kilo'.tr),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: width / 2,
                    height: height / 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                      child: FutureBuilder(
                          future: _fetch(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                            }
                            return SimpleBuilder(builder: (_) {
                              return GestureDetector(
                                onTap: () {},
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const AutoSizeText('Hedef Kilonuz',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign:
                                                    TextAlign.center, maxLines:1),
                                            weightTarget != null ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                AutoSizeText(
                                                    '${weightTarget.toString()} ',
                                                    style: const TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight
                                                                .w600), maxLines:1),
                                                const Text('kg',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight
                                                                .w500))
                                              ],
                                            ) : const Text('(Girilmedi)',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          }),
                    ),
                  ),
                  SizedBox(
                    width: width / 2,
                    height: height / 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _usersStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            return SimpleBuilder(builder: (_) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 3.0, left: 3.0),
                                child: GestureDetector(
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
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                child: AutoSizeText('Bugünkü Kilonuz',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign:
                                                        TextAlign.center, maxLines:1),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: snapshot
                                                    .data!.docs
                                                    .map((DocumentSnapshot
                                                        document) {
                                                  Map<String, dynamic>
                                                      data =
                                                      document.data()!
                                                          as Map<String,
                                                              dynamic>;
                                                  return Center(
                                                    child: data['dailyDate']
                                                                .toString() ==
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(
                                                                    _selectedDate)
                                                                .toString()
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              AutoSizeText(
                                                                  "${data['dailyWeight']} "
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight.w600), maxLines:1),
                                                              const Text('kg',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight.w500))
                                                            ],
                                                          )
                                                        : null,
                                                  );
                                                }).toList(),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
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
                                  onTap: () {},
                                ),
                              );
                            });
                          }
                          return Center(
                              child: Lottie.asset(
                            'assets/images/98635-loading.json',
                            width: 150,
                            height: 150,
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: width / 2,
                    height: height / 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _startWeight,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            return SimpleBuilder(builder: (_) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 3.0, left: 3.0),
                                child: GestureDetector(
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
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
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
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                child: AutoSizeText(
                                                    'Başlangıç Kilonuz',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign:
                                                        TextAlign.center,maxLines: 1,),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: snapshot
                                                    .data!.docs
                                                    .map((DocumentSnapshot
                                                        document) {
                                                  Map<String, dynamic>
                                                      data =
                                                      document.data()!
                                                          as Map<String,
                                                              dynamic>;
                                                  return Center(
                                                    child:
                                                        data['dailyWeight'] !=
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
                                                                      "${data['dailyWeight']} "
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize: 30,
                                                                          fontWeight: FontWeight.w600), maxLines:1),
                                                                  const Text('kg',
                                                                      style: TextStyle(
                                                                          fontSize: 25,
                                                                          fontWeight: FontWeight.w500))
                                                                ],
                                                              )
                                                            : null,
                                                  );
                                                }).toList(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              );
                            });
                          }
                          return Center(
                              child: Lottie.asset(
                            'assets/images/98635-loading.json',
                            width: 150,
                            height: 150,
                          ));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 2,
                    height: height / 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _usersStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            return SimpleBuilder(builder: (_) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 3.0, left: 3.0),
                                child: GestureDetector(
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
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                                child: AutoSizeText('Ortalama Kilonuz',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign:
                                                        TextAlign.center, maxLines:1),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: snapshot
                                                    .data!.docs
                                                    .map((DocumentSnapshot
                                                        document) {
                                                  Map<String, dynamic>
                                                      data =
                                                      document.data()!
                                                          as Map<String,
                                                              dynamic>;
                                                  var ortToplama =
                                                      counter += data[
                                                          "dailyWeight"];
                                                  bolmeList.add(
                                                      data["dailyWeight"]);
                                                  var ortBolme =
                                                      bolmeList.length;
                                                  var ortSonuc =
                                                      (ortToplama /
                                                          ortBolme);
                                                  return Center(
                                                    child: data['dailyDate']
                                                                .toString() ==
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(
                                                                    _selectedDate)
                                                                .toString()
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [ AutoSizeText(
                                                                  "${ortSonuc.toStringAsFixed(2)} "
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight.w600), maxLines:1),
                                                              const Text('kg',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight.w500))
                                                            ],
                                                          )
                                                        : null,
                                                  );
                                                }).toList(),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
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
                                  onTap: () {},
                                ),
                              );
                            });
                          }
                          return Center(
                              child: Lottie.asset(
                            'assets/images/98635-loading.json',
                            width: 150,
                            height: 150,
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width / 2.1,
                    height: height / 6,
                    child: FutureBuilder(
                        future: _fetchOne(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                          }
                          var a = yesterdayWeightDb != null
                              ? dailyWeightDb != null
                                  ? dailyWeightDb - yesterdayWeightDb
                                  : 0
                              : 0;
                          return SizedBox(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                          child: AutoSizeText('Günlük Değişim',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w500),
                                              textAlign: TextAlign.center, maxLines:1),
                                        ),
                                        yesterdayWeightDb != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  a != null
                                                      ? Text(
                                                          a.toStringAsFixed(
                                                              1),
                                                          style: const TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                                      : const Text('Boş'),
                                                  const SizedBox(width: 5),
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              )
                                            : const Text('(Girilmedi)',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500))
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
                    width: width / 2.1,
                    height: height / 6,
                    child: FutureBuilder(
                        future: _fetchTwo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                          }
                          return SizedBox(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                          child: AutoSizeText('Dünkü Kilonuz',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w500),
                                              textAlign: TextAlign.center, maxLines:1),
                                        ),
                                        yesterdayDateDb != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  yesterdayDateDb
                                                              .toString() ==
                                                          DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(
                                                                  _dateYestreday)
                                                              .toString()
                                                      ? AutoSizeText(
                                                          yesterdayWeightDb
                                                              .toStringAsFixed(
                                                                  1),
                                                          style: const TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600), maxLines:1)
                                                      : const Text('Boş'),
                                                  const SizedBox(width: 5),
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              )
                                            : const Text('(Girilmedi)',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        color: Color(0xFF486A71)),
                                    width: 15,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width / 2.1,
                    height: height / 6,
                    child: FutureBuilder(
                        future: _fetchThree(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                          }
                          var lastWeek = lastWeekWeightDb != null
                              ? dailyWeightDb != null
                                  ? lastWeekWeightDb - dailyWeightDb
                                  : 0
                              : 0;
                          return SizedBox(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                          child: AutoSizeText('Haftalık Değişim',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w500),
                                              textAlign: TextAlign.center, maxLines:1),
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
                                                  lastWeek != null
                                                      ? AutoSizeText(
                                                          lastWeek.abs()
                                                              .toStringAsFixed(
                                                                  1),
                                                          style: const TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),maxLines:1)
                                                      : const Text('Boş'),
                                                  const SizedBox(width: 5),
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              )
                                            : const Text('(Girilmedi)',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500))
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
                    width: width / 2.1,
                    height: height / 6,
                    child: FutureBuilder(
                        future: _fetchFour(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Shimmer.fromColors(
                                baseColor: Color(0xFF285C71),
                                highlightColor: Color(0xFFAAB4BB),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const AutoSizeText('Hedef Kilonuz',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign:
                                                      TextAlign.center, maxLines:1),
                                              weightTarget != null ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              ) : const Text('(Girilmedi)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              );
                          }
                          var a = lastMoonWeightDb != null
                              ? dailyWeightDb != null
                                  ? lastMoonWeightDb - dailyWeightDb
                                  : 0
                              : 0;
                          return SizedBox(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                          child: AutoSizeText('Aylık Değişim',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w500),
                                              textAlign: TextAlign.center, maxLines:1),
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600), maxLines:1)
                                                      : const Text('Boş'),
                                                  const SizedBox(width: 5),
                                                  const Text('kg',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500))
                                                ],
                                              )
                                            : const Text('(Girilmedi)',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
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
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
