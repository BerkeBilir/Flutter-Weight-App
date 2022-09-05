import 'package:flutter/material.dart';
import 'package:flutter_hive/bottom_nav_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'main.dart';
import 'screens/mainscreen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List locale = [
    {'name': 'Türkçe'.tr, 'locale': const Locale('tr', 'TR')},
    {'name': 'İngilizce'.tr, 'locale': const Locale('en', 'US')},
  ];

  final controller = Get.put(Controller());
  final box = GetStorage();

  ChangeLanguageAlertDialog(BuildContext context) {
// set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text('Lütfen bir dil seçiniz'.tr, textAlign: TextAlign.center)),
      content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      child: Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                              child: Text(locale[index]['name'],
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white))),
                        ),
                      ),
                      onTap: () {
                              updateLanguage(locale[index]['locale']);
                            }
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.grey,
                );
              },
              itemCount: locale.length)),
    );
// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleBuilder(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(onPressed: () {Get.offAll(const BottomNavBarPage());}, icon: const Icon(Icons.arrow_back)),
            centerTitle: true,
            title: Text('Ayarlar'.tr),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                    child: GestureDetector(
                      child: Card(
                        elevation: 1,
                        child: Center(
                          child: Text('Dil Seçiniz'.tr,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      onTap: () {
                        ChangeLanguageAlertDialog(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                    child: GestureDetector(
                      child: Card(
                        elevation: 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Tema',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(
                                height: 10,
                              ),
                              Transform.scale(
                                scale: 1.8,
                                child: Switch(
                                  activeThumbImage: const AssetImage(
                                      'assets/images/half-moon.png'),
                                  inactiveThumbImage: const AssetImage(
                                      'assets/images/sunny.png'),
                                  value: controller.isDark,
                                  onChanged: controller.changeTheme,
                                ),
                              )
                            ]),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 3.0, left: 3.0),
                    child: GestureDetector(
                      child: Card(
                        elevation: 1,
                        child: Center(
                          child: Text('Çıkış Yap'.tr,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red)),
                        ),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                            title: 'Dikkat!',
                            titleStyle: const TextStyle(color: Colors.red, fontSize: 24),
                            titlePadding: const EdgeInsets.only(top: 10),
                            content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Çıkış yapmak istediğine emin misin?', style: TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                      onTap: () {Get.back();},
                                      child: const SizedBox(
                                          width: double.infinity,
                                          child: Card(
                                              color: Colors.blue,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(
                                                        12.0),
                                                child: Center(
                                                    child: Text('Vazgeç',
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              )))),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                      onTap: () {
                                        box.remove('userUid');
                                        box.erase();
                                        Get.offAll(const MainScreen());
                                        },
                                      child: const SizedBox(
                                          width: double.infinity,
                                          child: Card(
                                              color: Colors.red,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(
                                                        12.0),
                                                child: Center(
                                                    child: Text('Çıkış Yap',
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              )))),
                                ]));
                      },
                    ),
                  ),
                ]),
          ));
    });
  }
}
