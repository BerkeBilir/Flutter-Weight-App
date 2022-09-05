import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'friend_request.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({Key? key}) : super(key: key);

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  final firebaseUser = FirebaseAuth.instance.currentUser!;
  dynamic data = Get.arguments;
  bool? personPremissonDb;
  String? nameDb;
  String? surnameDb;
  String? urlDb;
  String? uniqeKeyDb;
  String? uidDb;
  bool? friendCheckDb = false;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("friends")
      .snapshots();

  final Stream<QuerySnapshot> _usersStreamTwo = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("friends")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Arkadaşlar'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.person_add)),
            ],
          )),
      body: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          FriendOne(usersStream: _usersStream),
          FriendTwo(usersStreamTwo: _usersStreamTwo, firebaseUser: firebaseUser)
        ],
      )),
    );
  }
}

class FriendTwo extends StatelessWidget {
  const FriendTwo({
    Key? key,
    required Stream<QuerySnapshot<Object?>> usersStreamTwo,
    required this.firebaseUser,
  }) : _usersStreamTwo = usersStreamTwo, super(key: key);

  final Stream<QuerySnapshot<Object?>> _usersStreamTwo;
  final User firebaseUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStreamTwo,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return data['friendCheck'] == false
                      ? Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                                onTap: null,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "${data['imageUrl']}",
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      data['name'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      data['surname'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(data['uniqeKey']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(firebaseUser.uid)
                                              .collection('friends')
                                              .doc(data['uid'])
                                              .delete();
                                        },
                                        icon: const Icon(Icons.clear,
                                            color: Colors.red)),
                                    IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(firebaseUser.uid)
                                              .collection('friends')
                                              .doc(data['uid'])
                                              .update({
                                            'friendCheck': true,
                                          });
                                          // .then((value) {
                                          //   Get.defaultDialog(
                                          //       title:
                                          //           'Arkadaş Eklendi',
                                          //       titleStyle:
                                          //           const TextStyle(
                                          //               color: Colors
                                          //                   .green,
                                          //               fontSize: 24),
                                          //       titlePadding:
                                          //           const EdgeInsets
                                          //                   .only(
                                          //               top: 10),
                                          //       content: Column(
                                          //         children: [
                                          //           SizedBox(
                                          //               height: 10),
                                          //           Text(
                                          //               'Sen de arkadaşını takip etmek ister misin?',
                                          //               style: TextStyle(
                                          //                   fontSize:
                                          //                       18,
                                          //                   fontWeight:
                                          //                       FontWeight
                                          //                           .w500),
                                          //               textAlign:
                                          //                   TextAlign
                                          //                       .center),
                                          //           SizedBox(
                                          //               height: 15),
                                          //           Row(children: [
                                          //             Expanded(
                                          //               child: GestureDetector(
                                          //                   onTap: () {
                                          //                     Get.back();
                                          //                   },
                                          //                   child: const SizedBox(
                                          //                       width: double.infinity,
                                          //                       child: Card(
                                          //                           color: Colors.blue,
                                          //                           child: Padding(
                                          //                             padding: EdgeInsets.all(12.0),
                                          //                             child: Center(child: Text('Vazgeç', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600))),
                                          //                           )))),
                                          //             ),
                                          //             Expanded(
                                          //               child: GestureDetector(
                                          //                   onTap: _addFriend,
                                          //                   child: const SizedBox(
                                          //                       width: double.infinity,
                                          //                       child: Card(
                                          //                           color: Colors.green,
                                          //                           child: Padding(
                                          //                             padding: EdgeInsets.all(12.0),
                                          //                             child: Center(child: Text('Geri takip et', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600))),
                                          //                           )))),
                                          //             ),
                                          //           ]),
                                          //         ],
                                          //       ));
                                          // });
                                        },
                                        icon: const FaIcon(
                                            FontAwesomeIcons
                                                .circleCheck,
                                            color: Colors.green)),
                                  ],
                                )),
                          ),
                        )
                      : const Center();
                }).toList(),
              ),
            );
          }
          return Center(
              child: Lottie.asset(
            'assets/images/98635-loading.json',
            width: 150,
            height: 150,
          ));
        });
  }
}



class FriendOne extends StatelessWidget {
  const FriendOne({
    Key? key,
    required Stream<QuerySnapshot<Object?>> usersStream,
  }) : _usersStream = usersStream, super(key: key);

  final Stream<QuerySnapshot<Object?>> _usersStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return data['friendCheck'] == true
                      ? Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              onTap: () {
                                Get.to(const FriendRequestPage(),
                                    arguments: [data]);
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "${data['imageUrl']}",
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    data['surname'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(data['uniqeKey']),
                            ),
                          ),
                        )
                      : const Center();
                }).toList(),
              ),
            );
          }
          return Center(
              child: Lottie.asset(
            'assets/images/98635-loading.json',
            width: 150,
            height: 150,
          ));
        });
  }
}
