import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

enum Menu {
  itemOne,
  itemTwo,
  itemThree,
  itemFour,
  itemFive,
  itemSix,
  itemSeven,
  itemEight
}

class PersoInfoDailyWeight extends StatefulWidget {
  const PersoInfoDailyWeight({Key? key}) : super(key: key);

  @override
  State<PersoInfoDailyWeight> createState() => _PersoInfoDailyWeightState();
}

class _PersoInfoDailyWeightState extends State<PersoInfoDailyWeight> {
  final firebaseUser = FirebaseAuth.instance.currentUser!;

  List todos = List.empty();
  String title = "";
  dynamic weight = 0;
  String _selectedMenu = 'Hepsi';
  final DateTime _dateNow = DateTime.now();
  final DateTime _dateLastWeek =
      DateTime.now().subtract(const Duration(days: 7));

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamOne = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(7)
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamTwo = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(14)
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamThree = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(30)
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamFour = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(90)
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamFive = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(180)
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamSix = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(270)
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamSeven = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("dailyInfo")
      .orderBy("timesTamp", descending: true)
      .limit(365)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Günlük Kilo Geçmişi'),
        actions: [
          Center(
            child: PopupMenuButton<Menu>(
              icon: Icon(Icons.filter_alt_rounded),
                onSelected: (Menu item) {
                  setState(() {
                    _selectedMenu = item.name;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      const PopupMenuItem<Menu>(
                        value: Menu.itemOne,
                        child: Text('1 Hafta'),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemTwo,
                        child: Text('2 Hafta'),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemThree,
                        child: Text('1 Ay'),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemFour,
                        child: Text('3 Ay'),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemFive,
                        child: Text('6 Ay'),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemSix,
                        child: Text('9 Ay'),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemSeven,
                        child: Text('1 Yıl'),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemEight,
                        child: Text('Hepsi'),
                      ),
                    ]),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _selectedMenu == 'itemOne'
            ? _usersStreamOne
            : _selectedMenu == 'itemTwo'
                ? _usersStreamTwo
                : _selectedMenu == 'itemThree'
                    ? _usersStreamThree
                    : _selectedMenu == 'itemFour'
                        ? _usersStreamFour
                        : _selectedMenu == 'itemFive'
                            ? _usersStreamFive
                            : _selectedMenu == 'itemSix'
                                ? _usersStreamSix
                                : _selectedMenu == 'itemSeven'
                                    ? _usersStreamSeven
                                    : _selectedMenu == 'itemEight'
                                        ? _usersStream
                                        : _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return data['dailyDate'] != null
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: data != null
                                        ? Text(data['dailyDate'].toString(),
                                            style: const TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600))
                                        : const Text('Boş')),
                                Expanded(
                                    child: data != null
                                        ? Text(
                                            "${data['dailyWeight'].toString()} kg",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600))
                                        : const Text('Boş')),
                              ],
                            ),
                          ),
                        )
                      : Center();
                }).toList(),
              ),
            );
          }
          return Center(
              child: Lottie.asset(
            'assets/images/98635-loading.json',
            width: 150,
            height: 150,
          ));
        },
      ),
    );
  }
}
