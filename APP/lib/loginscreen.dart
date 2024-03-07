import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:stellarpowers/dashboard.dart';
import 'package:stellarpowers/userreg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
     final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
    late ProgressDialog _progressDialog;
    
     @override
  void initState() {
    super.initState();
    _progressDialog = ProgressDialog(context);
  }

  Future<void> login() async {
    try {
              _progressDialog.show();

      final FirebaseAuth auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordcontroller.text.trim(),
        );

      print(userCredential.user?.uid);

        String? userId = userCredential.user?.uid;
        if (userId != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ));
        } else {
          _progressDialog.hide();

          print('Failed to fetch student status.');
        }
      }

       catch (e) {
        
        _progressDialog.hide();

     String errorMessage = 'Login failed';

        if (e is FirebaseAuthException) {
          errorMessage = e.code;
        }

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
                  'SIGN IN',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Welcom Back',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 550,
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
                            controller: _emailController,
                            decoration: InputDecoration(
                                hintText: "Email or phone number",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child:  TextFormField(
                            controller: _passwordcontroller,
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                     login();
                    },
                    style: const ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(200, 50)),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 234, 149, 45)),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Userreg(),
                          ));
                    },
                    style: const ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(200, 50)),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 234, 149, 45)),
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
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
