import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/bottom_nav_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:spring/spring.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKeyNS = GlobalKey<FormState>();
  final formKeyPhone = GlobalKey<FormState>();
  final box = GetStorage();
  String? name;
  String? surname;
  String? phone;
  String? phoneDb;
  String? nameDb;
  String? surnameDb;
  String? emailDb;
  String? url;
  String? urlDb;
  bool isChecked = true;
  bool? checkBoxDb;
  bool infoSharePermisson = true;
  bool? infoSharePermissonDb;
  String? uniqeKeyDb;
  String? errorMessage = '';

  var firebaseUser = FirebaseAuth.instance.currentUser!;

  var maskFormatter = MaskTextInputFormatter(
      mask: '0(xxx) xxx-xxxx',
      filter: {"x": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.eager);


  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      nameDb = ds['name'];
      surnameDb = ds['surname'];
      emailDb = ds['email'];
      phoneDb = ds['phone'];
      urlDb = ds['imageUrl'];
      uniqeKeyDb = ds['uniqeKey'];
      checkBoxDb = ds['infoPermisson'];
      infoSharePermissonDb = ds['infoSharePermisson'];
    }).catchError((e) {
      print(e);
    });
  }


  _popUpPhone() {
    Get.defaultDialog(
        title: 'Dikkat!'.tr,
        titleStyle: const TextStyle(color: Colors.red, fontSize: 24),
        titlePadding: const EdgeInsets.only(top: 10),
        content: Form(
          key: formKeyPhone,
          child: Column(children: [
            const Text(
                'Telefon numarası eklemek veya değiştirmek istediğine emin misin?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline),
                labelText: 'Telefon Numaranız'.tr,
                hintText: phoneDb ?? 'Telefon Numaranız'.tr,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen boş bırakmayınız';
                }
                return null;
              },
              onChanged: (value) => setState(() {
                phone = value;
              }),
              keyboardType: TextInputType.number,
              inputFormatters: [
                MaskTextInputFormatter(
                    mask: 'x(xxx) xxx-xxxx',
                    filter: {"x": RegExp(r'[0-9]')},
                    type: MaskAutoCompletionType.eager),
              ],
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SizedBox(
                        width: double.infinity,
                        child: Card(
                            color: Colors.blue,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(
                                  child: Text('Vazgeç'.tr,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600))),
                            )))),
              ),
              Expanded(
                child: GestureDetector(
                    onTap: _updatePhone,
                    child: SizedBox(
                        width: double.infinity,
                        child: Card(
                            color: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(
                                  child: Text('Kaydet'.tr,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600))),
                            )))),
              ),
            ])
          ]),
        ));
  }

  _updatePhone() async {
    try {
      if (formKeyPhone.currentState!.validate()) {
        final firebaseUser = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          'phone': phone,
        }).then((_) {
          Get.offAll(const BottomNavBarPage());
        }).then((_) {
          Get.snackbar(
            '',
            "",
            titleText: const Text("Başarılı",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            messageText: const Text("Telefon numarası başarıyla kaydedildi.",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        Get.snackbar(
          '',
          "",
          titleText: const Text("Hata Mesajı",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
          messageText: Text("${errorMessage = e.message}",
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        );
      });
    }
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      url = await ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update({'imageUrl': url});
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
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
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('Profil'.tr),
            ),
            body: Stack(children: [
              Positioned(
                bottom: -10,
                left: -10,
                right: -10,
                child: Spring.animatedCard(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  fromColor: box.read('darkmode') == false ? const Color(0xFFE9E9E9) : const Color(0xFF212121),
                  toColor: box.read('darkmode') == false ? const Color(0xFFBDBDBD) : const Color(0xFF616161),
                  fromWidth: 0,
                  toWidth: width,
                  fromHeight: 0,
                  toHeight: height / 1.40,
                  heightDuration: const Duration(milliseconds: 1000),
                  child: FutureBuilder(
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
                        return Stack(children: [
                          Positioned(
                              top: height / 10,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: Icon(Icons.person),
                                    title: Row(
                                      children: [
                                        Text('$nameDb ',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500)),
                                        Text('$surnameDb',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    )
                                  ),
                                ),
                              )),
                          Positioned(
                              top: height / 5.5,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: const Icon(Icons.email),
                                    title: AutoSizeText('$emailDb ',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500))
                                  ),
                                ),
                              )),
                          Positioned(
                              top: height / 3.8,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: const Icon(Icons.person),
                                    title: Row(
                                      children: [
                                        Text('Kullanıcı Adınız: '.tr,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500)),
                                                Text('$uniqeKeyDb',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500))
                                      ]
                                    )
                                  ),
                                ),
                              )),
                              Positioned(
                              top: height / 2.9,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: const FaIcon(
                                                FontAwesomeIcons.phone),
                                    title: phoneDb == null ? const AutoSizeText('Telefon numarası ekle',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),maxLines: 1) : Text(phoneDb.toString(),
                                                  style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500)),
                                                trailing: IconButton(
                                            onPressed: _popUpPhone,
                                            icon: const Icon(Icons.edit),
                                          ),
                                  ),
                                ),
                              )),
                              Positioned(
                              top: height / 2.35,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: const Icon(Icons.security),
                                    title: AutoSizeText('Diğer kullanıcılardan arkadaşlık isteği alınsın mı?'.tr,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),maxLines: 2),
                                                trailing: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.blue,
                                              value: checkBoxDb ?? isChecked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  final firebaseUser =
                                                      FirebaseAuth.instance
                                                          .currentUser!;
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(firebaseUser.uid)
                                                      .update({
                                                    'infoPermisson': value,
                                                  });
                                                });
                                              },
                                            ),
                                  ),
                                ),
                              )),
                              Positioned(
                              top: height / 1.96,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: const FaIcon(
                                                    FontAwesomeIcons
                                                        .userSecret),
                                    title: AutoSizeText('Bilgilerin arkadaşlarınla paylaşılsın mı?'.tr,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),maxLines: 2),
                                                trailing: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.blue,
                                              value: infoSharePermissonDb ??
                                                  infoSharePermisson,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  final firebaseUser =
                                                      FirebaseAuth.instance
                                                          .currentUser!;
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(firebaseUser.uid)
                                                      .update({
                                                    'infoSharePermisson': value,
                                                  });
                                                });
                                              },
                                            ),
                                  ),
                                ),
                              )),
                        ]);
                      }),
                ),
              ),
              Positioned(
                  bottom: height / 2,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.all(100.0),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Spring.fadeIn(
                          animDuration: const Duration(milliseconds: 1500),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              urlDb!,
                            ),
                          ),
                        )),
                  )),
              Positioned(
                  bottom: height / 1.62,
                  left: 86,
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                              icon: const FaIcon(FontAwesomeIcons.camera),
                              onPressed: () {
                                _showPicker(context);
                              },
                              color: Colors.white)))),
            ]));
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('Galeri'.tr),
                  onTap: () {
                    imgFromGallery();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('Kamera'.tr),
                onTap: () {
                  imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
