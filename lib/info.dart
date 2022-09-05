import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'bottom_nav_bar.dart';
import 'result.dart';
class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {


  num _value = 0;
  num height = 180;
  num weight = 70;
  num age = 20;
  DateTime _selectedDate = DateTime.now();


  void pickDate(BuildContext context) async {
    var initialDate = DateTime.now();
    _selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: initialDate.add(const Duration(days: 0))) ??
        _selectedDate;
    setState(() {DateFormat('dd/MM/yyyy').format(_selectedDate).toString();});
  }

  _update() async {
    Get.defaultDialog(
      title: 'Veriler Kaydedildi ✓',
      titleStyle: const TextStyle(color: Colors.green, fontSize: 24),
      titlePadding: const EdgeInsets.only(top: 10),
      barrierDismissible: false,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {Get.to(const ResultPage());},
            child: const SizedBox(
              width: double.infinity,
              child: Card(
                color: Color(0xFF285C71),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(child: Text('Sonuçları Görüntüle', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600))),
                )
              )
            )
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {Get.offAll(const BottomNavBarPage());},
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text('Ana Sayfaya Dön', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline,)))
            )
          ),
        ]
      ),
    );
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .update(
          {
            'birthDay': _selectedDate,
            'gender': _value,
            'age': age,
            'height': height,
            'weight': weight,
          }
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detaylı Vücut Bilgiler'.tr),
      ),
      body: PersonInfo(),
    );
  }

  CustomScrollView PersonInfo() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: PersonInfoList,
    );
  }

  List<Widget> get PersonInfoList {
    return <Widget>[
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
        onTap: () {
          pickDate(context);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: AutoSizeText('Doğum Tarihinizi Giriniz'.tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                      ),
                      Text(DateFormat('dd/MM/yyyy').format(_selectedDate).toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
                    ],
                  )),
              ],
            ),
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
          (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 180,
                        child: GestureDetector(
                          onTap: () => setState(() => _value = 0),
                          child: Card(
                            child: Container(
                            color: _value == 0
                                ? const Color.fromARGB(255, 200, 200, 200)
                                : Colors.transparent,
                            child: const Icon(Icons.male,
                                size: 70, color: Color(0xFF285C71)),
                          ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 180,
                        child: GestureDetector(
                          onTap: () => setState(() => _value = 1),
                          child: Card(
                            child: Container(
                            color: _value == 1
                                ? const Color.fromARGB(255, 200, 200, 200)
                                : Colors.transparent,
                            child: const Icon(Icons.female,
                                size: 70, color: Colors.pink),
                          ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: 1,
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Center(
                          child: Text('Yaş'.tr,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      NumberPicker(
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        selectedTextStyle: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF285C71)),
                        value: age.toInt(),
                        minValue: 0,
                        maxValue: 220,
                        step: 1,
                        itemHeight: 100,
                        axis: Axis.horizontal,
                        onChanged: (value) => setState(() => age = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Color(0xFF285C71), width: 2.5),
                        ),
                      ),
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
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Boy'.tr,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500)),
                              const Text('(cm)',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      NumberPicker(
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        selectedTextStyle: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF285C71)),
                        value: height.toInt(),
                        minValue: 0,
                        maxValue: 220,
                        step: 1,
                        itemHeight: 100,
                        axis: Axis.horizontal,
                        onChanged: (value) => setState(() => height = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Color(0xFF285C71), width: 2.5),
                        ),
                      ),
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
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
            );
          },
          childCount: 1,
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
              onTap: _update,
              child: Container(
                color: const Color(0xFF486A71),
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
            );
          },
          childCount: 1,
        ),
      ),
    ];
  }
}


class Controller extends GetxController {
  final ageController  = TextEditingController();
}