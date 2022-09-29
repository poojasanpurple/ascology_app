
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/resent_otp_request.dart';
import 'package:ascology_app/model/request/user_verifyotp_request.dart';
import 'package:ascology_app/model/response/otp_response.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/agent_home.dart';
import 'package:ascology_app/screens/user_chang_passwd.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserVerifyOtp extends StatefulWidget {

  String mobile, usertype;

  UserVerifyOtp({this.mobile,this.usertype});


  @override
  _UserVerifyOtpState createState() => _UserVerifyOtpState();
}

class _UserVerifyOtpState extends State<UserVerifyOtp> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController otpController = TextEditingController();

//  bool isButtonClickable = true;
  bool _isVisible = true;
  bool _isVisible_sms = true;
  final formKey = GlobalKey<FormState>();

  String verify_mobile, verify_otp, user_type;

  int callotp_count = 0;
  int smsotp_count = 1;

  SharedPreferences logindata;

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
    user_type = widget.usertype;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Verify Otp', style: TextStyle(
              color: Colors.white,
              fontSize: 22
          ),),

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
                  SizedBox(height: 20.0,),

                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value.isEmpty
                        ? "Please enter OTP"
                        : null,
                    onSaved: (value) => verify_otp = value,
                    controller: otpController,
                    decoration: buildInputDecoration(
                        'Enter OTP', Icons.lock_open_outlined),
                  ),

                  SizedBox(height: 20.0,),


                  Center(child:
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    /*  Visibility(
                        visible: _isVisible,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.call,
                            size: 20,
                            //  Icons.facebook
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xffe22525)),
                          label: Text('Request OTP'),
                          onPressed: () {

                            (context);

                            *//* if (isButtonClickable) {
                          callforotp(context);
                        }
*//*

                          },

                        ),
                      ),*/


                    Visibility(
                      visible: _isVisible_sms,
                      child:
                      ElevatedButton.icon(
                        icon: Icon(Icons.email,
                          size: 20,

                          //  Icons.facebook
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xffe22525)),
                        label: Text('Resend OTP'),
                        onPressed: () {
                          sendmsgotp(context);
                        },


                      ),
                    )

                    ],
                  ),
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
                        // loginUser(context);
                        // Navigator.pushReplacementNamed(context, '/login');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);


                        getuserotp(context);
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

  void getuserotp(BuildContext context) async {
    // verify_email = emailController.text;
    //verify_mobile = mobileController.text;
    verify_otp = otpController.text;

    //  if (verify_mobile != null && verify_otp!=null) {
    if (verify_otp != null) {
      //  loaderFun(context, true);
      var _loginApiClient = LoginApiClient();
      UserVerifyOtpRequest userVerifyOtp = new UserVerifyOtpRequest();
      userVerifyOtp.mobile = verify_mobile;
      userVerifyOtp.otp = verify_otp;


      UserForgetPasswordResponseModel userModel =
      await _loginApiClient.userverifyotp(userVerifyOtp);
      print("!Q!Q!QQ!Q!Q!Q $userModel");
      if (userModel.status == true) {
        if (user_type == "User") {
          print(userModel.message);
          /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserChangePassword()),
              );*/

          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) {
                  return UserChangePassword(
                      mobile: verify_mobile, usertype: "User");
                },
              ));
        }
        /* if(user_type=="Agent")
              {
                print(userModel.message);
                */ /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserChangePassword()),
                );*/ /*
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UserChangePassword(mobile: verify_mobile, usertype :"Agent") ;
                      },
                    ));
              }*/


/*  setProgressVisibility = false;
            print('doneeeeeee :-${userModel.Ticket}');
            openDashboard(context, userModel);*/

      } else {
        //  loaderFun(context, false);
        print('Account does not exist');
      }
    } else {
      print('Please enter valid OTP.');
    }
  }

  void callforotp(BuildContext context) async {
    Duration time = Duration(seconds: 5);


    setState(() {
      callotp_count = 1;

      _isVisible = false;
      //  isButtonClickable = false;
    });

    /* Future<http.Response> fetchAlbum() async {
      return http.get(Uri.parse('https://asccology.com/call_api/otp_call.php?extension=${mobile}&${otp}'));
    }*/


  }

  void sendmsgotp(BuildContext context) async {


    if(smsotp_count <=3)
      {

        setState(() {
          smsotp_count = smsotp_count+ 1;


          _isVisible_sms = true;

        });



    logindata = await SharedPreferences.getInstance();

    //  loaderFun(context, true);
    var _loginApiClient = LoginApiClient();
    ResendOtpRequestModel loginRequestModel = new ResendOtpRequestModel();
    loginRequestModel.mobile = verify_mobile;

    OtpResponseModel userModel = await _loginApiClient.user_resendotp(
        loginRequestModel);
    print("!Q!Q!QQ!Q!Q!Q $userModel");
    if (userModel.status == true) {
      Fluttertoast.showToast(
          msg: "Wait a while....Otp sent to the given mobile number...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else {
      //  loaderFun(context, false);
     /* Fluttertoast.showToast(
          msg: "Invalid login details...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
*/

    }
  }
    else{
      setState(() {
        _isVisible_sms = false;
      });

    }
    }
}
