import 'package:flutter/material.dart';
import 'package:flutter_hive/target_det.dart';
import 'package:get/get.dart';
import 'target_weight_info.dart';

class TargetWeightPage extends StatefulWidget {
  const TargetWeightPage({Key? key}) : super(key: key);

  @override
  State<TargetWeightPage> createState() => _TargetWeightPageState();
}

class _TargetWeightPageState extends State<TargetWeightPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hesaplamalar'),
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
                            color: Colors.blue,
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
                            color: Colors.teal,
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
    );
  }
}
