import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stellarpowers/myservice.dart';
import 'package:stellarpowers/servicereq.dart';
import 'package:stellarpowers/myprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}



class _DashboardState extends State<Dashboard> {
  FirebaseFirestore db = FirebaseFirestore.instance;
List<Map<String, dynamic>> userProfile = [];
String name = '';

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
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
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
    });
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
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'DASHBOARD',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(
                  height: 1,
                ),
                const Text(
                  'welcome  ',
                  style: TextStyle(color: Colors.white),
                ),
                Text(name,
                    style: const TextStyle(
                      color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 700,
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
                    height: 60,
                  ),
                  Column(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Servicereq(),
                            ));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 173, 39),
                              borderRadius: BorderRadius.circular(20)),
                          height: 150,
                          width: 250,
                          child: const Center(
                              child: Text(
                            'Service Request',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Myservice(),
                            ));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 173, 39),
                              borderRadius: BorderRadius.circular(20)),
                          height: 150,
                          width: 250,
                          child: const Center(
                              child: Text(
                            'My service',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Myprofile(),
                            ));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 173, 39),
                              borderRadius: BorderRadius.circular(20)),
                          height: 150,
                          width: 250,
                          child: const Center(
                              child: Text(
                            'My Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))),
                    )
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
