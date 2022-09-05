import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'bottom_nav_bar.dart';
import 'gen.dart';
import 'onBoarding.dart';
class UserManagement {
  final box = GetStorage();
  storeNewUser(user, name, surname, email, phone, context) async {
    var firebaseUser = FirebaseAuth.instance.currentUser!;
    String? url = 'https://abs.twimg.com/sticky/default_profile_images/default_profile_400x400.png';
    bool? infoPermisson = true;
    bool? infoSharePermisson = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set({
          'infoPermisson': infoPermisson,
          'infoSharePermisson': infoSharePermisson,
          'uniqeKey': '@${generatePassword()}',
          'email': email,
          'name': name,
          'surname': surname,
          'phone': phone,
          'imageUrl': url,
          'birthDay': '',
          'gender': '',
          'age': '',
          'height': '',
          'weight': '', 
          'uid': user.uid
          }).then((value) async{
            box.write('userUid', firebaseUser.uid);
          })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBarPage())))
        .catchError((e) {
          print(e);
        });
  }
}