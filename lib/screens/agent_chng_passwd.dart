import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/userchng_passwd_request.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/screens/agent_login.dart';
import 'package:ascology_app/screens/login.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AgentChangePassword extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  String mobile, usertype;

  AgentChangePassword({this.mobile});

  @override
  _AgentChangePasswordState createState() => _AgentChangePasswordState();
}

class _AgentChangePasswordState extends State<AgentChangePassword> {

  final formKey = GlobalKey<FormState>();

  String  verify_mobile,user_type;

  String newpasswd,confirmpasswd;
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );


  @override
  Widget build(BuildContext context) {

    verify_mobile = widget.mobile;
    print('verify_mobile'+verify_mobile);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Agent Change Password', style: TextStyle(
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

                  TextFormField(
                    autofocus: false,
                    //validator: validateEmail,
                    controller: newpasswordcontroller,
                    onSaved: (value) => newpasswd = value,
                    decoration: buildInputDecoration(
                        'Enter new password', Icons.password),
                  ),

                  SizedBox(height: 20.0,),

                  TextFormField(
                    autofocus: false,
                    //validator: validateEmail,
                    controller: confirmpasswordcontroller,
                    onSaved: (value) => confirmpasswd = value,
                    decoration: buildInputDecoration(
                        'Enter new password', Icons.password),
                  ),


                  SizedBox(height: 20.0,),

                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xffe22525)),
                      child: Text(
                        "Submit", style: TextStyle(fontWeight: FontWeight
                          .w300),),
                      onPressed: () {
                       // user_chngpassword(context);
                        agent_chngpassword(context);
                        // Navigator.pushReplacementNamed(context, '/login');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);



                      }
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void agent_chngpassword(BuildContext context) async {
    newpasswd = newpasswordcontroller.text;
    confirmpasswd = confirmpasswordcontroller.text;

    if (newpasswd == confirmpasswd) {

      print('verify_mobile'+verify_mobile);
      //  loaderFun(context, true);
      var _loginApiClient = LoginApiClient();
      UserChangePasswordRequest changePasswordRequest = new UserChangePasswordRequest();
      changePasswordRequest.mobile = verify_mobile;
      changePasswordRequest.new_password = newpasswd;
      changePasswordRequest.confirm_password = confirmpasswd;

      UserChangePasswordResponseModel userModel = await _loginApiClient
          .agentchngpassword(changePasswordRequest);
      print("!Q!Q!QQ!Q!Q!Q $userModel");
      if (userModel.status == true) {
        print('Password sent to mobile number');

        Fluttertoast.showToast(
            msg: userModel.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AgentLogin()),
              (Route<dynamic> route) => false,
        );
      }

      else {
        //  loaderFun(context, false);
        print('Invalid mobile number');
      }
    }
    else {

      newpasswordcontroller.text = '';
      confirmpasswordcontroller.text = '';

      Fluttertoast.showToast(
          msg: "Passwords do not match, please provide valid passwords",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
  }

}
