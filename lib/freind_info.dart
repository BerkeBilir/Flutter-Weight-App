import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';
class FriendInfoPage extends StatefulWidget {
  const FriendInfoPage({Key? key}) : super(key: key);

  @override
  State<FriendInfoPage> createState() => _FriendInfoPageState();
}

class _FriendInfoPageState extends State<FriendInfoPage> {
  dynamic data = Get.arguments;
  bool? personPremissonDb;
  String? nameDb;
  String? surnameDb;
  String? urlDb;
  String? uniqeKeyDb;
  String? uidDb;
  bool? friendCheckDb = false;
  bool? friendDb;
  bool? friendTwoDb;

  final firebaseUser = FirebaseAuth.instance.currentUser!;

  _fetch() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(data[0]['uid'])
        .get()
        .then((ds) {
      personPremissonDb = ds['infoPermisson'];
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(data[0]['uid'])
        .collection('friends')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      friendDb = ds['friendCheck'];
    }).catchError((e) {
      print(e);
    });
    print(friendDb);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('friends')
        .doc(data[0]['uid'])
        .get()
        .then((ds) {
      friendTwoDb = ds['friendCheck'];
    }).catchError((e) {
      print(e);
    });
    print(friendTwoDb);
  }

  _addFriend() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("users")
        .doc(data[0]['uid'])
        .collection("friends")
        .doc(firebaseUser.uid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      nameDb = ds['name'];
      surnameDb = ds['surname'];
      urlDb = ds['imageUrl'];
      uniqeKeyDb = ds['uniqeKey'];
      uidDb = ds['uid'];
    }).then((value) {
      Get.snackbar(
        '',
        "",
        titleText: const Text("İstek Gönderildi",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
        messageText: const Text("Arkadaşlık isteği gönderildi",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      );
    });

    Map<String, dynamic> todoList = {
      "name": nameDb,
      "surname": surnameDb,
      "imageUrl": urlDb,
      "uniqeKey": uniqeKeyDb,
      "uid": uidDb,
      "friendCheck": friendCheckDb
    };
    documentReference.set(todoList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
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
                centerTitle: true,
                title: Text('Kişi Profili'.tr),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Center(
                  child: Column(children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(data[0]['imageUrl']))),
                    const SizedBox(height: 25),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(data[0]['name'],
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 5),
                          Text(data[0]['surname'],
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500)),
                        ]),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Kullanıcı Adı:',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white60)),
                          const SizedBox(width: 5),
                          Text(data[0]['uniqeKey'],
                              style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white60)),
                        ]),
                    personPremissonDb == true
                        ? personPremissonDb != null
                            ? Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: data[0]['uid'] != firebaseUser.uid ? EdgeInsets.all(0) : EdgeInsets.all(14.0),
                                    child: ElevatedButton(
                                        onPressed: data[0]['uid'] != firebaseUser.uid ? _addFriend : null,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: data[0]['uid'] != firebaseUser.uid ? const Text(
                                              'Arkadaşlık isteği gönder',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w500)) : const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                                                        child: AutoSizeText(
                                              'Kendini arkadaş olarak ekleyemezsin',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                        FontWeight.w500),textAlign: TextAlign.center , maxLines:1),
                                                      ),
                                        )),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Card(
                                    child: SizedBox(
                                  width: width / 0.5,
                                  height: height / 5.25,
                                  child: const Center(
                                      child: Text(
                                    'Kullanıcı arkadaşlık isteklerini kabul etmek istemediği için bilgilerini göremezsiniz.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )),
                                )),
                              )
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                                child: SizedBox(
                              width: width / 0.5,
                              height: height / 5.25,
                              child: const Center(
                                  child: Text(
                                'Kullanıcı arkadaşlık isteklerini kabul etmek istemediği için bilgilerini göremezsiniz.',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              )),
                            )),
                          )
                  ]),
                ),
              )
              );
        });
  }
}
