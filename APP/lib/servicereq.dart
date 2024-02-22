import 'package:flutter/material.dart';

class Servicereq extends StatefulWidget {
  const Servicereq({super.key});

  @override
  State<Servicereq> createState() => _ServicereqState();
}
 

class _ServicereqState extends State<Servicereq> {
  
   final TextEditingController _namecontroller = TextEditingController();
  
    void submit() {
    print(_namecontroller.text);
    }
    
    List<Map<String, dynamic>> type = [
    {'id': 'ongrid', 'name': 'ON GRID'},
    {'id': 'offgrid', 'name': 'OFF GRID'},
    {'id': 'homeinverter', 'name': 'HOME INVERTER'},
  ];

  String? selecttype;
  XFile? _selectedImage;
  String? _imageUrl;

  List<Map<String, dynamic>> kw = [
    {'id': '1kw', 'name': '1 KW'},
    {'id': '2kw', 'name': '2 KW'},
    {'id': '3kw', 'name': '3 KW'},
    {'id': '4kw', 'name': '4 KW'},
    {'id': '5kw', 'name': '5 KW'},
    {'id': '6kw', 'name': '6 KW'},
  ];

    String? selectkw;

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
                              ? FileImage(XFile(_selectedImage!.path))
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
                            keyboardType: TextInputType.multiline,
                            controller: _namecontroller,
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
                            value: selecttype,
                            decoration: InputDecoration(
                                hintText: "Type",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selecttype = newValue;
                              });
                            },
                            isExpanded: true,
                            items: type.map<DropdownMenuItem<String>>(
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
                            value: selectkw,
                            decoration: InputDecoration(
                                hintText: "kw",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectkw = newValue;
                              });
                            },
                            isExpanded: true,
                            items: kw.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> dist) {
                                return DropdownMenuItem<String>(
                                  value: dist['id'],
                                  child: Text(dist['name']),
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
                            submit();
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