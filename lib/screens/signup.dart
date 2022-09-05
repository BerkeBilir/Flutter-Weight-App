import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../auth.dart';
import 'mainscreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKeyTwo = GlobalKey<FormState>();
    String? name;
    String? surname;
    String? email;
    String? phone;
    String? password;
    String? confrimPassword;
    String? errorMessage = '';
    bool _isObscure = true;
    bool _isObscureTwo = true;
    bool _isLoading = false;

  Future<void> createUserWithEmailAndPassword() async {
    try {
      if (formKeyTwo.currentState!.validate()) {
        setState(() {
      _isLoading = true;
    });
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.toString(), password: password.toString())
                .whenComplete(()
            {
              setState(() {
                _isLoading = false;
            });})
            .then((signedInUser) {
          UserManagement().storeNewUser(signedInUser.user, name, surname, email, phone, context);
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        Get.snackbar(
          '',
          "",
          titleText: Text("Hata Mesajı",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
          messageText: Text("${errorMessage = e.message}",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: 1,
            itemBuilder:(context, index) 
            {
              return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hoşgeldiniz', style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700)),
                  SizedBox(height: 25),
                  Text('Lütfen Kayıt Olun', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                _createFormArea(),
                _createBackButton()
              ]
            );
            },
          ),
        )
        );
  }

  Widget _createFormArea() {
    return Form(
      key: formKeyTwo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _createNameArea(),
            const SizedBox(
              height: 15,
            ),
            _createSurnameArea(),
            const SizedBox(
              height: 15,
            ),
            _createEmailArea(),
            const SizedBox(
              height: 15,
            ),
            _createPasswordArea(),
            const SizedBox(
              height: 15,
            ),
            _createConfrimPasswordArea(),
            const SizedBox(
              height: 20,
            ),
            _createButton(),
          ],
        ),
      ),
    );
  }

  Widget _createNameArea() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'Lütfen boş bırakmayınız';
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline),
        labelText: 'Ad',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
      ),
      onChanged: (value) => setState(() {
        name = value;
      }),
    );
  }

  Widget _createSurnameArea() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'Lütfen boş bırakmayınız';
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline),
        labelText: 'Soyad',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
      ),
      onChanged: (value) => setState(() {
        surname = value;
      }),
    );
  }

  Widget _createEmailArea() {
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
        labelText: 'Email adres',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
      ),
      onChanged: (value) => setState(() {
        email = value;
      }),
    );
  }

  Widget _createPasswordArea() {
    return TextFormField(
      obscureText: _isObscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen boş bırakmayınız';
        } else if (value.length < 6) {
          return 'Lütfen 6 karakterden daha uzun şifre giriniz';
        } else if (password != confrimPassword) {
          return 'Şifreler uyuşmuyor';
        }
        return null;
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
        confrimPassword = value;
      }),
    );
  }

  Widget _createConfrimPasswordArea() {
    return TextFormField(
      obscureText: _isObscureTwo,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen boş bırakmayınız';
        } else if (value.length < 6) {
          return 'Lütfen 6 karakterden daha uzun şifre giriniz';
        } else if (password != confrimPassword) {
          return 'Şifreler uyuşmuyor';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
                icon: Icon(
                  _isObscureTwo ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscureTwo = !_isObscureTwo;
                  });
                },
              ),
          prefixIcon: const Icon(Icons.lock_outline),
          labelText: 'Şifre Onayla',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(22.0))),
      onChanged: (value) => setState(() {
        password = value;
      }),
    );
  }

  Widget _createButton() {
    return ElevatedButton(
        onPressed: createUserWithEmailAndPassword,
        style: ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    )
  )
),
        child: Padding(
            padding: _isLoading ?  EdgeInsets.symmetric(vertical: 6, horizontal: 0) : EdgeInsets.symmetric(vertical: 18, horizontal: 80),
            child: _isLoading ? Center(
                child: Lottie.asset(
              'assets/images/98635-loading.json',
              width: 50,
              height: 50,
            )) : Text(
              'Kayıt Ol',
              style: TextStyle(fontSize: 18.0),
            ),
          ));
  }

  Widget _createBackButton() {
    return GestureDetector(
      onTap: () {
        Get.offAll(MainScreen());
      },
      child: Center(child: Text('Daha önceden kayıt oldun mu? Giriş yap', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blue)))
    );
  }

}
