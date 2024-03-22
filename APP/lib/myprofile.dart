import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stellarpowers/editprofile.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
   FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> userProfile = [];
  String name = '';
  String phoneno = '';
  String address = '';
  String email = '';
  String image = '';

 
 @override
  void initState() {
    super.initState();
    fetchProfile();
  }
  Future<void> fetchProfile() async {
    try {
      List<Map<String, dynamic>> userList = [];
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_userreg')
              .where('user_id', isEqualTo: userId)
              .get();

      querySnapshot.docs.forEach((doc) {
        userList.add(doc.data());
      });
      print(userList[0]);
      setState(() {
        userProfile = userList;
        name = userList[0]['user_name'];
        phoneno = userList[0]['user_contact'];
        address = userList[0]['user_address'];
        email = userList[0]['user_email'];
        image = userList[0]['user_photo'];
      });
      print(name);
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromARGB(255, 247, 139, 37),
          Color.fromARGB(255, 244, 203, 56),
          Color.fromARGB(255, 255, 107, 38),
        ])),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'My profile',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60))),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 75,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: image.isNotEmpty
                                  ? NetworkImage(image) as ImageProvider
                                  : const AssetImage('assets/dummy.jpg'),
                            ),
                          ),
                          const SizedBox(
                            height: 75,
                          ),
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  SizedBox(width: 75, child: Text('Name:')),
                                  Text(name,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  SizedBox(width: 75, child: Text('Phone No:')),
                                  Text(phoneno,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                          // Container(
                          //     padding: const EdgeInsets.all(20),
                          //     decoration: const BoxDecoration(),
                          //     child: Row(
                          //       children: [
                          //         SizedBox(width: 75, child: Text('District:')),
                          //         Text('Ernakulam',
                          //             style: TextStyle(
                          //                 fontStyle: FontStyle.italic,
                          //                 fontWeight: FontWeight.bold))
                          //       ],
                          //     )),
                          // Container(
                          //     padding: const EdgeInsets.all(20),
                          //     decoration: const BoxDecoration(),
                          //     child: Row(
                          //       children: [
                          //         SizedBox(width: 75, child: Text('Place:')),
                          //         Text('Piravom',
                          //             style: TextStyle(
                          //                 fontStyle: FontStyle.italic,
                          //                 fontWeight: FontWeight.bold))
                          //       ],
                          //     )),
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  SizedBox(width: 75, child: Text('Address:')),
                                  Text(address,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  SizedBox(width: 75, child: Text('Email:')),
                                  Flexible(
                                    child: Text(email,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Editprofile(),
                                  ));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 250, 173, 39),
                                    borderRadius: BorderRadius.circular(20)),
                                height: 50,
                                width: 200,
                                child: Center(
                                    child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
