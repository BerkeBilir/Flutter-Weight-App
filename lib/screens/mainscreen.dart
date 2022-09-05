import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import '../screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? email;
  String? password;
  String? errorMessage = '';
  bool _isObscure = true;
  bool _isLoading = false;
  bool _isResertLoading = false;
  final box = GetStorage();

  final formKeyLogin = GlobalKey<FormState>();
  final resetKey = GlobalKey<FormState>();

  Future<void> signInWithEmailAndPassword() async {
    try {
      if (formKeyLogin.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        var firebaseUser = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((value) => setState(() {
                  box.write('userUid', firebaseUser!.uid);
                }));
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.toString(), password: password.toString())
            .whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            })
            .then((user) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavBarPage())))
            .catchError((e) {
              setState(() {
                Get.snackbar(
                  '',
                  "",
                  titleText: const Text("Hata Mesajı",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
                  messageText: Text("${errorMessage = e.message}",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                );
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

  Future<void> resetGetPassword() async {
    try {
      if (resetKey.currentState!.validate()) {
        setState(() {
          _isResertLoading = true;
        });
        var firebaseUser = FirebaseAuth.instance.currentUser;
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.toString());
        Get.snackbar(
          '',
          "",
          titleText: const Text("Email Gönderildi",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
          messageText: const Text("Email adresinizi kontrol ediniz",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 6),
        );
      } else {
        Get.snackbar(
          '',
          "",
          titleText: const Text("Hata",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
          messageText: const Text("Email adresinizi kontrol ediniz",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 6),
        );
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

  Future<void> resetPassword() async {
    Get.defaultDialog(
        title: 'Şifre Değiştirme',
        titleStyle: const TextStyle(color: Colors.green, fontSize: 24),
        titlePadding: const EdgeInsets.only(top: 10),
        content: Column(children: [
          SizedBox(height: 10),
          Text('Şifrenizi değiştirmek için Email adresinizi yazınız.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text('(Email gözükmüyorsa spam kutunuza bakınız.)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
          SizedBox(height: 20),
          Form(
              key: resetKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                        return 'Lütfen boş bırakmayınız';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: 'Email Adres',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                    ),
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: resetGetPassword,
                        child: _isLoading
              ? Center(
                  child: Lottie.asset(
                  'assets/images/98635-loading.json',
                  width: 50,
                  height: 50,
                ))
              : Text('Gönder',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w600))),
                  )
                ],
              )),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Hoşgeldiniz',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 25),
                  const Text('Lütfen Giriş Yapınız',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  _signFormArea(),
                  const SizedBox(height: 25),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Center(
                          child: Text('Yeni kullanıcı mısın? Hemen kayıt ol',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue)))),
                ]);
          },
        ),
      ),
    );
  }

  Widget _signFormArea() {
    return Form(
      key: formKeyLogin,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _signEmailArea(),
            const SizedBox(
              height: 30,
            ),
            _signPasswordArea(),
            const SizedBox(
              height: 20,
            ),
            _forgotPasswordArea(),
            const SizedBox(
              height: 20,
            ),
            _signButton(),
          ],
        ),
      ),
    );
  }

  Widget _signEmailArea() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Lütfen boş bırakmayınız';
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'Email Adres',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
      ),
      onChanged: (value) => setState(() {
        email = value;
      }),
    );
  }

  Widget _signPasswordArea() {
    return TextFormField(
      obscureText: _isObscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen boş bırakmayınız';
        }
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          prefixIcon: const Icon(Icons.lock_outline),
          labelText: 'Şifre',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(22.0))),
      onChanged: (value) => setState(() {
        password = value;
      }),
    );
  }

  Widget _forgotPasswordArea() {
    return GestureDetector(
        onTap: resetPassword,
        child: const Center(
            child: Text('Şifrenizi mi unuttunuz?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))));
  }

  Widget _signButton() {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ))),
        onPressed: _isLoading ? null : signInWithEmailAndPassword,
        child: Padding(
          padding: _isLoading
              ? EdgeInsets.symmetric(vertical: 6, horizontal: 0)
              : EdgeInsets.symmetric(vertical: 18, horizontal: 80),
          child: _isLoading
              ? Center(
                  child: Lottie.asset(
                  'assets/images/98635-loading.json',
                  width: 50,
                  height: 50,
                ))
              : Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 18.0),
                ),
        ));
  }
}
