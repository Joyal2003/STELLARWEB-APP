import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Myservice extends StatefulWidget {
  const Myservice({Key? key}) : super(key: key);

  @override
  State<Myservice> createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
  final TextEditingController _feedbackcontroler = TextEditingController();

  List<Map<String, dynamic>> serviceData = [];
  late String uId;
  Future<void> _storeData() async {
    try {
      print(uId);
      print(_feedbackcontroler.text);
      await FirebaseFirestore.instance
          .collection('tbl_servicerequest')
          .doc(uId)
          .update({'feedback_content': _feedbackcontroler.text});
      print('Feedback updated successfully');
      _feedbackcontroler.clear();
      Fluttertoast.showToast(
        msg: "Thank You for your feedback",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print('error feedback: $e');
      Fluttertoast.showToast(
        msg: "Operation Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      QuerySnapshot<Map<String, dynamic>> fetchData = await FirebaseFirestore
          .instance
          .collection('tbl_servicerequest')
          .where('user_id', isEqualTo: userId)
          .get();
      List<Map<String, dynamic>> data = [];
      for (var doc in fetchData.docs) {
        try {
          data.add({
            'id': doc.id,
            'service_content': doc['service_content'],
            'service_status': doc['service_status'],
          });
        } catch (e) {
          print('Error fetching district for place ${doc.id}: $e');
        }
      }
      setState(() {
        serviceData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  String? status(int val) {
    if (val == 0) {
      return 'Pending';
    } else if (val == 1) {
      return 'accepted';
    } else if (val == 2) {
      return 'rejected';
    } else if (val == 3) {
      return 'completed';
    } else {
      return null;
    }
  }

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
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'My service',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(225, 95, 27, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 75),
                          const SizedBox(height: 75),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(),
                            child: serviceData.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: serviceData.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(serviceData[index]
                                            ['service_content']),
                                        subtitle: Text(status(serviceData[index]
                                                ['service_status'])
                                            .toString()),
                                        trailing: serviceData[index]
                                                    ['service_status'] ==
                                                3
                                            ? IconButton(
                                                icon: const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green),
                                                onPressed: () {
                                                  setState(() {
                                                    uId = serviceData[index]
                                                        ['id'];
                                                  });
                                                  showFeedbackDialog(context);
                                                },
                                              )
                                            : null,
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 40),
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

  showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Provide Feedback"),
          content: TextFormField(
            controller: _feedbackcontroler,
            decoration:
                const InputDecoration(hintText: "Enter your feedback here"),
            maxLines: null, // Allow multiline input
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                _storeData();

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
