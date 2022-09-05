import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'services/local_notification_service.dart';
import 'bottom_nav_bar.dart';

class DailyWeightPage extends StatefulWidget {
  const DailyWeightPage({Key? key}) : super(key: key);

  @override
  State<DailyWeightPage> createState() => _DailyWeightPageState();
}

class _DailyWeightPageState extends State<DailyWeightPage> {

  final firebaseUser = FirebaseAuth.instance.currentUser!;

  DateTime _selectedDate = DateTime.now();
  dynamic weight = 70;

  addDailyWeight() async{
    await service.showScheduledNotification();
    Get.defaultDialog(
      title: 'Veriler Kaydedildi ✓',
      titleStyle: const TextStyle(color: Colors.green, fontSize: 24),
      titlePadding: const EdgeInsets.only(top: 10),
      barrierDismissible: false,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Eğer kilonuzu yanlış girdiyseniz değiştirebilirsiniz', style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.center),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {Get.offAll(const BottomNavBarPage());},
            child: const SizedBox(
              width: double.infinity,
              child: Card(
                color: Color(0xFF285C71),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(child: Text('Ana Sayfa', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))),
                )
              ) 
            )
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {Get.back();},
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text('Kilonuzu değiştirin', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline,)))
            )
          ),
        ]
        )
    );
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).collection("dailyInfo").doc(DateFormat('dd-MM-yyyy').format(_selectedDate).toString());

    Map<String, dynamic> todoList = {
      'dailyDate': DateFormat('dd/MM/yyyy').format(_selectedDate).toString(),
      "dailyWeight": weight,
      "timesTamp": Timestamp.now(),
    };
    documentReference
        .set(todoList);
  }


  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Günlük Kilo Girişi'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
            children: [
                const Text('Bugünün Tarihi', style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                Text(DateFormat('dd/MM/yyyy').format(_selectedDate).toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          ),
              )),
              const SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Kilo'.tr,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)),
                              const Text('(kg)',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Center(
                          child: DecimalNumberPicker(
                            value: weight.toDouble(),
                            minValue: 0,
                            maxValue: 200,
                            itemCount: 1,
                            itemHeight: 100,
                            axis: Axis.horizontal,
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            selectedTextStyle: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF285C71)),
                            onChanged: (value) => setState(() => weight = value),
                            integerDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Color(0xFF285C71), width: 2.5),
                          ),
                            decimalDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Color(0xFF285C71), width: 2.5),
                          ),
                          ),
                        ),
                      ],
                    ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
              onTap: addDailyWeight,
              child: Container(
                color: Color(0xFF285C71),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                      child: Text('Kaydet'.tr,
                          style: const TextStyle(color: Colors.white, fontSize: 22))),
                ),
              ),
          ),
                ),
              ),
              ],
        ),
      ),
    );
  }
  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => const DailyWeightPage())));
    }
  }
}
