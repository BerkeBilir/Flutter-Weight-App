import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/freind_info.dart';
import 'package:get/get.dart';

class CloudFirestoreSearch extends StatefulWidget {
  const CloudFirestoreSearch({Key? key}) : super(key: key);

  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {


  var firebaseUser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userMap;
  String? errorMessage = '';
  String name = "";

  final addFriend = GlobalKey<FormState>();

  Future<void> onSearch() async {
    try {
      if (addFriend.currentState!.validate()) {
        FirebaseFirestore.instance
        .collection('users')
        .where("uniqeKey", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    });
    FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        if (userMap != null) {
          userMap = value.docs[0].data();
        } else {
          userMap ??= value.docs[0].data();
        }
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Arkadaş Ekle"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 24.0, right: 12.0, left: 12.0),
              child: Form(
                key: addFriend,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
              setState(() {
                name = val;
                try {
      if (addFriend.currentState!.validate()) {
        FirebaseFirestore.instance
        .collection('users')
        .where("uniqeKey", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    });
    FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        if (userMap != null) {
          userMap = value.docs[0].data();
        } else {
          userMap ??= value.docs[0].data();
        }
      });
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .where("keyWords", isEqualTo: name)
    //     .get()
    //     .then((value) {
    //   setState(() {
    //     if (userMap != null) {
    //       userMap = value.docs[0].data();
    //     } else {
    //       userMap ??= value.docs[0].data();
    //     }
    //   });
    // });
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
              });
            },
                  decoration: InputDecoration(
                    hintText: "kullanıcı adı veya email adresi giriniz.",
                    suffixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 1.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(7),
  ),
                        color: const Color(0xFF486A71),
                        child: IconButton(
                          onPressed: onSearch,
                          icon: const Icon(Icons.search, size: 30, color: Colors.white),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen boş bırakmayınız';
            } else if (value == '@') {
              return 'Lütfen boş bırakmayınız';
            }
            return null;
            },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          userMap != null
              ? Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                      onTap: () {
                        Get.to(const FriendInfoPage(), arguments: [userMap]);
                      },
                      leading: 
                      CircleAvatar(
                              backgroundImage: NetworkImage(
                                "${userMap!['imageUrl']}",
                              ),
                            ),
                      title: Row(
                        children: [
                          Text(
                            userMap!['name'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            userMap!['surname'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(userMap!['uniqeKey']),
                      trailing: const Icon(Icons.person_add)
                    ),
                ),
              )
              : const Expanded(
                  child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Card(
                          child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                        'Arkadaş eklemek için @ ile başlayan kullanıcı adını veya email adresini yazınız.',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ))),
                )),
        ],
      ),
    );
  }
}
