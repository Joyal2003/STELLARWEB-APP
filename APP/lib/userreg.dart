import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class Userreg extends StatefulWidget {
  const Userreg({super.key});

  @override
  State<Userreg> createState() => _UserregState();
}

class _UserregState extends State<Userreg> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  XFile? _selectedImage;
  String? _imageUrl;
  String? filePath;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phonenumbercontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  List<Map<String, dynamic>> district = [];
  List<Map<String, dynamic>> place = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  late ProgressDialog _progressDialog;

  String selectdistrict = "";
  String selectplace = "";

  Future<void> fetchDistrict() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('tbl_district').get();

      List<Map<String, dynamic>> dist = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'district': doc['district_name'].toString(),
              })
          .toList();
      setState(() {
        district = dist;
      });
      print(district);
    } catch (e) {
      print('Error fetching department data: $e');
    }
  }

  Future<void> fetchPlace(String id) async {
    try {
      selectplace = '';
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
          .collection('tbl_place')
          .where('district_id', isEqualTo: id)
          .get();
      List<Map<String, dynamic>> plc = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'place': doc['place_name'].toString(),
              })
          .toList();
      setState(() {
        place = plc;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _registerUser() async {
    try {
      _progressDialog.show();

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordcontroller.text,
      );

      if (userCredential != null) {
        await _storeUserData(userCredential.user!.uid);
        Fluttertoast.showToast(
          msg: "Registration Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _progressDialog.hide();
        Navigator.pop(context);
      }
    } catch (e) {
      _progressDialog.hide();
      Fluttertoast.showToast(
        msg: "Registration Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Error registering user: $e");
      // Handle error, show message, or take appropriate action
    }
  }

  Future<void> _storeUserData(String userId) async {
    try {
      await db.collection('tbl_userreg').add({
        'user_id': userId,
        'user_name': _namecontroller.text,
        'user_email': _emailController.text,
        'user_contact': _phonenumbercontroller.text,
        'user_address': _addresscontroller.text,
        'place_id': selectplace,
        // Add more fields as needed
      });
      await _uploadImage(userId);
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  Future<void> _uploadImage(String userId) async {
    try {
      if (_selectedImage != null) {
        print(_selectedImage);
        Reference ref =
            FirebaseStorage.instance.ref().child('User/Photo/$userId.jpg');
        UploadTask uploadTask = ref.putFile(File(_selectedImage!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        Map<String, dynamic> newData = {
          'imageUrl': imageUrl,
        };
        await db
            .collection('tbl_userreg')
            .where('user_id', isEqualTo: userId) // Filtering by user_id
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            // For each document matching the query, update the data
            doc.reference.update(newData);
          });
        }).catchError((error) {
          print("Error updating user: $error");
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
      // Handle error, show message or take appropriate action
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = XFile(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDistrict();
    _progressDialog = ProgressDialog(context);
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
                  'Create Account',
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xff4c505b),
                          backgroundImage: _selectedImage != null
                              ? FileImage(File(_selectedImage!.path))
                              : _imageUrl != null
                                  ? NetworkImage(_imageUrl!)
                                  : const AssetImage('assets/logo.png')
                                      as ImageProvider,
                          child: _selectedImage == null && _imageUrl == null
                              ? const Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Color.fromARGB(255, 41, 39, 39),
                                )
                              : null,
                        ),
                        if (_selectedImage != null || _imageUrl != null)
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18,
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
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
                            controller: _namecontroller,
                            decoration: const InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: TextFormField(
                            controller: _phonenumbercontroller,
                            decoration: const InputDecoration(
                                hintText: "Phone number",
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
                            value: selectdistrict.isNotEmpty
                                ? selectdistrict
                                : null,
                            decoration: const InputDecoration(
                                hintText: "District",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectdistrict = newValue!;
                                fetchPlace(newValue);
                              });
                            },
                            isExpanded: true,
                            items: district.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> dist) {
                                return DropdownMenuItem<String>(
                                  value: dist['id'],
                                  child: Text(dist['district']),
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
                            value: selectplace.isNotEmpty ? selectplace : null,
                            decoration: const InputDecoration(
                                hintText: "Place",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectplace = newValue!;
                              });
                            },
                            isExpanded: true,
                            items: place.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> plc) {
                                return DropdownMenuItem<String>(
                                  value: plc['id'],
                                  child: Text(plc['place']),
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
                          child: TextFormField(
                            controller: _addresscontroller,
                            decoration: const InputDecoration(
                                hintText: "Address",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: TextFormField(
                            controller: _passwordcontroller,
                            decoration: const InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _registerUser();
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 234, 149, 45)),
                          ),
                          child: const Text(
                            "Create",
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
