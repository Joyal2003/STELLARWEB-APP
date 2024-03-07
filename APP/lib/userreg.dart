import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
   FirebaseFirestore db = FirebaseFirestore.instance;

  void create() {
    print(_namecontroller.text);
    print(_phonenumbercontroller);
    print(_addresscontroller);
    print(_emailController.text);
    print(_passwordcontroller.text);
  }

  List<Map<String, dynamic>> district = [
    {'id': 'ernakulam', 'name': 'Ernakulam'},
    {'id': 'idukki', 'name': 'Idukki'},
    {'id': 'kottayam', 'name': 'Kottayam'},
  ];

  String? selectdistrict;
  XFile? _selectedImage;
  String? _imageUrl;

  List<Map<String, dynamic>> place = [
    {'id': 'piravom', 'name': 'piravom'},
    {'id': 'thodupuzha', 'name': 'thodupuzha'},
    {'id': 'pala', 'name': 'pala'},
  ];
  String? selectplace;

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
                            decoration: InputDecoration(
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
                            decoration: InputDecoration(
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
                            value: selectdistrict,
                            decoration: InputDecoration(
                                hintText: "District",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectdistrict = newValue;
                              });
                            },
                            isExpanded: true,
                            items: district.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> dist) {
                                return DropdownMenuItem<String>(
                                  value: dist['id'],
                                  child: Text(dist['name']),
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
                            value: selectplace,
                            decoration: InputDecoration(
                                hintText: "Place",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectplace = newValue;
                              });
                            },
                            isExpanded: true,
                            items: place.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> dist) {
                                return DropdownMenuItem<String>(
                                  value: dist['id'],
                                  child: Text(dist['name']),
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
                            decoration: InputDecoration(
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
                            decoration: InputDecoration(
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
                            decoration: InputDecoration(
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
                            create();
                          },
                          style: const ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size(200, 50)),
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