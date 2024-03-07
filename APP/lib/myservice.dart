import 'package:flutter/material.dart';

class Myservice extends StatefulWidget {
  const Myservice({super.key});

  @override
  State<Myservice> createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
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
                  'My service',
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
                         const SizedBox(
                          height: 75,
                        ),
                        // Center(
                        //   child: Container(
                        //     child: Image.asset('assets/logo.png',),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 75,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(

                             ),
                          child: Row(
                            children: [
                              SizedBox(width: 75, child: Text('Name:')),
                              Text('Joyal',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                            ],
                          )
                        ),
                       
                      //   Container(
                      //     padding: const EdgeInsets.all(20),
                      //     decoration: const BoxDecoration(
                      //         ),
                      //     child:Row(
                      //       children: [
                      //         SizedBox(width: 75, child: Text('Phone No:')),
                      //         Text('987654321',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                      //         ],)
                      //   ),
                         
                      //   Container(
                      //    padding: const EdgeInsets.all(20),
                      //     decoration: const BoxDecoration(
                      //         ),
                      //     child: Row(
                      //       children: [
                      //         SizedBox(width: 75, child: Text('District:')),
                      //         Text('Ernakulam',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold))
                      //       ],
                      //     ) 
                      //   ),
                         
                      //   Container(
                      //  padding: const EdgeInsets.all(20),
                      //     decoration: const BoxDecoration(
                      //        ),
                      //     child:Row(
                      //       children: [
                      //         SizedBox(width: 75, child: Text('Place:')),
                      //         Text('Piravom',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold))
                      //       ],
                      //     )
                      //   ),
                        
                      //   Container(
                      //    padding: const EdgeInsets.all(20),
                      //     decoration: const BoxDecoration(
                      //         ),
                      //     child: Row(
                      //       children: [
                      //         SizedBox(width: 75, child: Text('Address:')),
                      //         Text('Poomkottukuzhiyil',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold))
                      //       ],
                      //     )
                      //   ),
                        
                      //   Container(
                      //    padding: const EdgeInsets.all(20),
                      //     decoration: const BoxDecoration(
                      //        ),
                      //     child: Row(
                      //       children: [
                      //         SizedBox(width: 75, child: Text('Email:')),
                      //         Text('joyalthomas2727@gmail.com',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold))
                      //       ],
                      //     )
                      //   ),
                       
                        const SizedBox(
                          height: 40,
                        ),
                    //    GestureDetector(
                    //   onTap: () {
                    //      Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const Editprofile(),
                    //       ));
                    //   },
                    // child: Container(
                    //   decoration: BoxDecoration(
                    //     color: Color.fromARGB(255, 250, 173, 39),
                    //     borderRadius: BorderRadius.circular(20)
                    // ),
                    //   height: 50,
                    //   width : 200,
                    //   child :Center(child: Text('Edit Profile',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                    // ),
                    // ),
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