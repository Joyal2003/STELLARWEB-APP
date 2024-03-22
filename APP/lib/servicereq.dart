import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  late ProgressDialog _progressDialog;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
          _progressDialog.show();

    try {
      String formattedDate = now.toString().substring(0, 10);
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      QuerySnapshot querySnapshot = await db
          .collection('tbl_userreg')
          .where('user_id', isEqualTo: userId)
          .get();
      await db.collection('tbl_user').where('user_id', isEqualTo: userId).get();
      await db.collection('tbl_servicerequest').add({
        'user_id': querySnapshot.docs[0].id,
        'service_content': _complaintcontroller.text,
        'producttype_id': selectproducttype,
        'type_id': selecttype,
        'service_status': 0,
        'date': 'd',
        'feedback_content': '',
        'service_date': formattedDate,
        // Add more fields as needed
      });
              _progressDialog.hide();

       Fluttertoast.showToast(
          msg: "Complaint Registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      print(querySnapshot.docs[0].id);
      Navigator.pop(context);
    } catch (e) {
              _progressDialog.hide();

      Fluttertoast.showToast(
          msg: "Something went wrong!. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      print('error service request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchproducttype();
    fetchtype();
    _progressDialog = ProgressDialog(context);
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 247, 139, 37),
              Color.fromARGB(255, 244, 203, 56),
              Color.fromARGB(255, 255, 107, 38),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Service Request',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                controller: _complaintcontroller,
                                decoration: InputDecoration(
                                  hintText: "Complaint",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a complaint';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectproducttype.isNotEmpty
                                    ? selectproducttype
                                    : null,
                                decoration: InputDecoration(
                                  hintText: "Type",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectproducttype = newValue!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a product type';
                                  }
                                  return null;
                                },
                                items: producttype
                                    .map<DropdownMenuItem<String>>(
                                      (Map<String, dynamic> dist) {
                                    return DropdownMenuItem<String>(
                                      value: dist['id'],
                                      child: Text(dist['producttype']),
                                    );
                                  }).toList(),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selecttype.isNotEmpty ? selecttype : null,
                                decoration: InputDecoration(
                                  hintText: "kw",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selecttype = newValue!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a type';
                                  }
                                  return null;
                                },
                                items: type
                                    .map<DropdownMenuItem<String>>(
                                      (Map<String, dynamic> dist) {
                                    return DropdownMenuItem<String>(
                                      value: dist['id'],
                                      child: Text(dist['type']),
                                    );
                                  }).toList(),
                              ),
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _storeUserData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200, 50),
                                primary: Color.fromARGB(255, 234, 149, 45),
                              ),
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 40),
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
      ),
    );
  }
}
