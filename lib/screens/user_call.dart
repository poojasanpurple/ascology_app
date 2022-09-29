

import 'package:flutter/material.dart';

class UserCall extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _UserCallState createState() => _UserCallState();
}

class _UserCallState extends State<UserCall> {

  final formKey = GlobalKey<FormState>();

  String user_email;
  TextEditingController emailcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Call', style: TextStyle(
              color: Colors.white,
              fontSize: 22
          ),) ,

          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/getnow.png'),
                    fit: BoxFit.fill
                )
            ),
          ),

        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
