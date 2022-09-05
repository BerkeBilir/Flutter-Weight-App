import 'package:flutter/material.dart';
import 'package:flutter_hive/bottom_nav_bar.dart';
import 'package:get/get.dart';
import 'info.dart';
import 'result.dart';

class PersonInfoPage extends StatefulWidget {
  const PersonInfoPage({Key? key}) : super(key: key);

  @override
  State<PersonInfoPage> createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Vücut Bilgiler'.tr),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.off(const BottomNavBarPage());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
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
                              color: Colors.blue,
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
                              color: Colors.teal,
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
    );
  }
}
