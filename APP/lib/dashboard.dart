import 'package:flutter/material.dart';
import 'package:stellarpowers/myservice.dart';
import 'package:stellarpowers/servicereq.dart';
import 'package:stellarpowers/myprofile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'DASHBOARD',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  'Welcom to stellar',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
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
                Column(
                  children :[
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
                          color: Color.fromARGB(255, 250, 173, 39),
                          borderRadius: BorderRadius.circular(20)
                      ),
                        height: 150,
                        width : 250,
                        
                        child :Center(child: Text('Service Request',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                      ),
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
                        color: Color.fromARGB(255, 250, 173, 39),
                        borderRadius: BorderRadius.circular(20)
                    ),
                      height: 150,
                      width : 250,
                      child :Center(child: Text('My service',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                    ),
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
                        color: Color.fromARGB(255, 250, 173, 39),
                        borderRadius: BorderRadius.circular(20)
                    ),
                      height: 150,
                      width : 250,
                      child :Center(child: Text('My Profile',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                    ),
                    )
                  ]
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