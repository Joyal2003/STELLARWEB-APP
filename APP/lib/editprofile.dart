import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phonenumbercontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  



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
        _namecontroller.text = userList[0]['user_name'];
        _phonenumbercontroller.text = userList[0]['user_contact'];
        _addresscontroller.text = userList[0]['user_address'];
       
      });
    } catch (e) {
      print(e);
    }
  }
 @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> updateProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      await FirebaseFirestore.instance
          .collection('tbl_userreg')
          .where('user_id', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'user_name': _namecontroller.text,
            'user_contact': _phonenumbercontroller.text,
            'user_address': _addresscontroller.text,
          });
        });
      });
      Fluttertoast.showToast(
          msg: "Profile Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
                  'Edit Profile',
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
                  // GestureDetector(
                  //   onTap: _pickImage,
                  //   child: Stack(
                  //     children: [
                  //       CircleAvatar(
                  //         radius: 50,
                  //         backgroundColor: const Color(0xff4c505b),
                  //         backgroundImage: _selectedImage != null
                  //             ? FileImage(File(_selectedImage!.path))
                  //             : _imageUrl != null
                  //                 ? NetworkImage(_imageUrl!)
                  //                 : const AssetImage('assets/logo.png')
                  //                     as ImageProvider,
                  //         child: _selectedImage == null && _imageUrl == null
                  //             ? const Icon(
                  //                 Icons.add,
                  //                 size: 40,
                  //                 color: Color.fromARGB(255, 41, 39, 39),
                  //               )
                  //             : null,
                  //       ),
                  //       if (_selectedImage != null || _imageUrl != null)
                  //         const Positioned(
                  //           bottom: 0,
                  //           right: 0,
                  //           child: CircleAvatar(
                  //             backgroundColor: Colors.white,
                  //             radius: 18,
                  //             child: Icon(
                  //               Icons.edit,
                  //               size: 18,
                  //               color: Colors.black,
                  //             ),
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  // ),
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
                          child: TextFormField(
                            controller: _addresscontroller,
                            decoration: InputDecoration(
                                hintText: "Address",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            updateProfile();
                          },
                          style: const ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size(200, 50)),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 234, 149, 45)),
                          ),
                          child: const Text(
                            "Save",
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