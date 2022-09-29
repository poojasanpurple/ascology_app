
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/forget_passwd_request.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/agent_verify_otp.dart';
import 'package:ascology_app/screens/user_verify_otp.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class UserForgotPassword extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _UserForgotPasswordState createState() => _UserForgotPasswordState();
}

class _UserForgotPasswordState extends State<UserForgotPassword> {

  final formKey = GlobalKey<FormState>();

  String user_mobile;
  TextEditingController mobilecontroller = TextEditingController();
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Forgot Password', style: TextStyle(
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
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: mobilecontroller,
                    onSaved: (value) => user_mobile = value,
                    decoration: buildInputDecoration(
                        'Enter mobile number', Icons.phone),
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
                        user_forgotpassword(context);
                        // Navigator.pushReplacementNamed(context, '/login');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);
                      /*  Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),
                              (Route<dynamic> route) => false,
                        );*/

                        Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserVerifyOtp(mobile: user_mobile,usertype :"User");
                              },
                            ));

                      },
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

  void user_forgotpassword(BuildContext context) async {
    user_mobile = mobilecontroller.text;

        //  loaderFun(context, true);
        var _loginApiClient = LoginApiClient();
        UserForgetPasswdRequestModel forgetPasswdRequestModel = new UserForgetPasswdRequestModel();
        forgetPasswdRequestModel.mobile = user_mobile;

        UserForgetPasswordResponseModel userModel = await _loginApiClient
            .userforgotPassword(forgetPasswdRequestModel);
        print("!Q!Q!QQ!Q!Q!Q $userModel");
        if (userModel.status == true) {
          print('Password sent to mobile number');

          Flushbar(
            title: ' ',
            message: userModel.message,
            duration: Duration(seconds: 10),
          ).show(context);


        }
        else {
          //  loaderFun(context, false);
          print('Invalid mobile number');
        }





  }
}
