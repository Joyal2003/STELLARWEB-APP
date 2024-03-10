import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class Servicereq extends StatefulWidget {
  const Servicereq({super.key});

  @override
  State<Servicereq> createState() => _ServicereqState();
}

class _ServicereqState extends State<Servicereq> {
  final TextEditingController _complaintcontroller = TextEditingController();
  List<Map<String, dynamic>> producttype = [];
  List<Map<String, dynamic>> type = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime now = DateTime.now();

  Future<void> fetchproducttype() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('tbl_producttype').get();

      List<Map<String, dynamic>> pt = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'producttype': doc['producttype_name'].toString(),
              })
          .toList();
      setState(() {
        producttype = pt;
      });
      print(producttype);
    } catch (e) {
      print('Error fetching department data: $e');
    }
  }

  Future<void> fetchtype() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('tbl_type').get();
      List<Map<String, dynamic>> tType = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'type': doc['type_name'].toString(),
              })
          .toList();
      setState(() {
        type = tType;
      });
    } catch (e) {
      print(e);
    }
  }


 Future<void> _storeUserData() async {
    try {
      String formattedDate = now.toString().substring(0, 10);
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      await db.collection('tbl_servicerequest').add({
        'user_id': userId,
        'service_content': _complaintcontroller.text,
        'producttype_name': selectproducttype,
        'type_name': selecttype,
        'service_status':0,
        'date':'d',
        'feedback_content':'',
        'service_date':formattedDate,
        // Add more fields as needed
      });
      print('Inserted');
    }catch(e){
      print('error service request: $e');
    }
 }
  void initState() {
    super.initState();
    fetchproducttype();
    fetchtype();
  }

  void submit() {
    print(_complaintcontroller.text);
  }

  String selectproducttype = '';
  String selecttype = '';

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
                  'Service Request',
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
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            controller: _complaintcontroller,
                            decoration: InputDecoration(
                                hintText: "Complaint",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: DropdownButtonFormField<String>(
                            value: selectproducttype.isNotEmpty
                                ? selectproducttype
                                : null,
                            decoration: InputDecoration(
                                hintText: "Type",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectproducttype = newValue!;
                              });
                            },
                            isExpanded: true,
                            items: producttype.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> dist) {
                                return DropdownMenuItem<String>(
                                  value: dist['id'],
                                  child: Text(dist['producttype']),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: DropdownButtonFormField<String>(
                            value: selecttype.isNotEmpty ? selecttype : null,
                            decoration: InputDecoration(
                                hintText: "kw",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selecttype = newValue!;
                              });
                            },
                            isExpanded: true,
                            items: type.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> dist) {
                                return DropdownMenuItem<String>(
                                  value: dist['id'],
                                  child: Text(dist['type']),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _storeUserData();
                          },
                          style: const ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size(200, 50)),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 234, 149, 45)),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
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
    ));
  }
}
