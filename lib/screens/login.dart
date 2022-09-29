import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/global/http_web_call.dart';
import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/login_request.dart';
import 'package:ascology_app/model/response/login_response.dart';
import 'package:ascology_app/screens/agent_login.dart';
import 'package:ascology_app/screens/agent_register.dart';
import 'package:ascology_app/screens/register.dart';
import 'package:ascology_app/screens/registermain.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/screens/user_forgtpasswd.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:ascology_app/global/configFile.dart' as cf;

import 'package:ascology_app/utility/validator.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String apkversion = '1.1';

  String _userName, _password,user_id,user_mobile,user_email,user_name,user_password,user_fcmtoken;
  String deviceName = '';
  String device_model = '';
  String deviceVersion = '';
  String identifier = '';
  String token = '';
  String imei_number = '';

  SharedPreferences logindata;
  bool newuser;
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    check_if_already_login();
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

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
     /* Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => UserHomePage()));*/
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => UserDashboard()));
    }
    /*else
      {
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => RegisterMain()));
      }*/
  }


 /* @override
  Future<void> launchUrl(String url) async {
    final _canLaunch = await canLaunch(url);
    if (kIsWeb) {
      if (_canLaunch) {
        await launch(url);
      } else {
        throw "Could not launch $url";
      }
      return;
    }
    if (TargetPlatform.android) {
      if (url.startsWith("https://www.facebook.com/")) {
        final url2 = "fb://facewebmodal/f?href=$url";
        final intent2 = AndroidIntent(action: "action_view", data: url2);
        final canWork = await intent2.canResolveActivity();
        if (canWork) return intent2.launch();
      }
      final intent = AndroidIntent(action: "action_view", data: url);
      return intent.launch();
    } else {
      if (_canLaunch) {
        await launch(url, forceSafariVC: false);
      } else {
        throw "Could not launch $url";
      }
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);

    return SafeArea(
      child:Scaffold(
          resizeToAvoidBottomInset: false,
        body:Flex( direction: Axis.vertical,
            children: [
            Expanded(
        child: SingleChildScrollView
          (
          child:

          Container(
        margin: EdgeInsets.fromLTRB(0.0,0,0,20),
           // height: MediaQuery.of(context).size.height / 2.1,  // Also Including Tab-bar height.
            height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.
              width: MediaQuery.of(context).size.width,

            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg_image_new.jpg"),
                    fit: BoxFit.fill)),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

            Container(
            margin: const EdgeInsets.all(25.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
            border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(40), // if you need this

        ),
                child:
                Column(

                    mainAxisAlignment: MainAxisAlignment.center,

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30,50,30,20),
                  alignment: Alignment.center,
                  child: TextFormField(
                    autofocus: false,
                    style: TextStyle(color: Colors.black,fontSize: cf.Size.blockSizeHorizontal*3.2),
                    //validator: validateEmail,
                    keyboardType: TextInputType.number,
                    controller: usernameController,
                    maxLength: 10,
                    onSaved: (value) => _userName = value,
                    decoration: buildInputDecorationlogin(
                        'Username / Mobile', Icons.call),
                  ),
                ),

                // SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(30.0,0,30.0,0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    style: TextStyle(color: Colors.black,fontSize: cf.Size.blockSizeHorizontal*3.2),
                    validator: (value) =>
                    value.isEmpty ? "Please enter password" : null,
                    onSaved: (value) => _password = value,
                    controller: passwordController,
                    decoration:
                    buildInputDecorationlogin('Password', Icons.lock),
                  ),
                ),



                Container(
                  alignment: Alignment.center,
                  child: FlatButton(
                    child: Text(
                      "Forgot password ?",
                      style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserForgotPassword()),
                            (Route<dynamic> route) => false,
                      );
                      // Navigator.pushReplacementNamed(context, '/login');
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);
                    },
                  ),
                ),

                SizedBox(height: 3),


                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Logging in...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    loginUser(context);
                    //print('do something');
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(
                        50.0, 10, 50.0, 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:const Color(0xffe22525),
                      border: Border.all( width: 1,color: const Color(0xffe22525)),
                      borderRadius: const BorderRadius.all(Radius.circular(40)),

                    ), // button text
                    child: Text("LOGIN", style: TextStyle(
                        fontFamily: 'Poppins bold',
                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                        fontWeight: FontWeight.bold,
                        backgroundColor: const Color(0xffe22525),
                        color: Colors.white

                    ),),
                  ),
                ),



                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Not a member yet? ',
                        style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.8,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                          text: 'Sign Up Now',
                          style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.8,
                            color: const Color(0xffe22525),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()),
                              );
                            }),
                    ]),
                  ),
                ),

               /* Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: ImageIcon(
                            AssetImage('assets/images/fb.png'),
                            size: 25,
                            color: const Color(0xffe22525),
                            //  Icons.facebook
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: ImageIcon(
                            AssetImage('assets/images/twitter.png'),
                            size: 25,
                            color: const Color(0xffe22525),

                            //  Icons.facebook
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: ImageIcon(
                            AssetImage('assets/images/instagram.png'),
                            size: 25,
                            color: const Color(0xffe22525),

                            //  Icons.facebook
                          ),
                          onPressed: () {},
                        ),
                      ]),
                ),*/

                      SizedBox(height: 15),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AgentLogin()),
                    );
                    //print('do something');
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(
                        50.0, 0, 50.0, 50.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all( width: 1,color: const Color(0xffe22525),),
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/getnow.png'),
                          fit: BoxFit.cover
                      ),
                    ), // button text
                    child: Text("Agent Login", style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: cf.Size.blockSizeHorizontal*3.8,
                        color: Colors.white

                    ),),
                  ),
                ),


                     // SizedBox(height: 15),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Agent_Register()),
                          );
                          //print('do something');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: EdgeInsets.fromLTRB(
                              50.0, 0, 50.0, 50.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all( width: 1,color: const Color(0xffe22525),),
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                           color: Colors.white
                           /* image: const DecorationImage(
                                image: AssetImage('assets/images/getnow.png'),
                                fit: BoxFit.cover
                            ),*/
                          ), // button text
                          child: Text("Agent Sign Up", style: TextStyle(
                              fontFamily: 'Poppins',
                              //fontWeight: FontWeight.bold,
                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                              color: Colors.red

                          ),),
                        ),
                      ),
      ],),
            ),
              ],
            ),


          ),



           //   ],
      //  ),



    ))])));
  }


  void loginUser(BuildContext context) async {
    _userName = usernameController.text;
    _password = passwordController.text;
    String fcmtoken = await FirebaseMessaging.instance.getToken();
    print(fcmtoken);
    logindata = await SharedPreferences.getInstance();


      if (_userName.length ==10 && _password.isNotEmpty) {

          //  loaderFun(context, true);
          var _loginApiClient = LoginApiClient();
          // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
          LoginRequestModel loginRequestModel = LoginRequestModel();
          //_userName,_password,'1234','','',apkversion,'');
          loginRequestModel.mobile = _userName;
          loginRequestModel.password = _password;
          loginRequestModel.token = fcmtoken;
          loginRequestModel.device_name = '';
          loginRequestModel.device_model = '';
          loginRequestModel.apk_version = apkversion;
          loginRequestModel.imei_number = '';

          LoginResponseModel userModel =
          await _loginApiClient.loginUser(loginRequestModel);

          print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
          // (data?.isEmpty ?? true
          //  if (userModel?.status ?? true) {
          //   if (userModel!=null) {
        //  if (userModel.status == true) {
          if (userModel.status == true) {
            print('User Login successful');
            Fluttertoast.showToast(
                msg: "Login successful...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            );
            user_id = userModel.user_id;
            print(user_id);
            user_email = userModel.email;
            user_mobile = userModel.mobile;
            user_name = userModel.name;
            user_password = userModel.password;
            user_fcmtoken = userModel.token;

            logindata.setBool('userlogin', false);
            logindata.setString('user_id', user_id);
            logindata.setString('user_type', "User");
            logindata.setString('user_email', user_email);
            logindata.setString('user_mobile', user_mobile);
            logindata.setString('user_name', user_name);
            logindata.setString('user_password', user_password);
            logindata.setString('user_fcmtoken', user_fcmtoken);

          /*  Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserHomePage()),
            );*/

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserDashboard()),
            );
          }
          else {

            Fluttertoast.showToast(
                msg: "Invalid login details...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            );
            print('User Login failed');
          }

      }

    else
      {

        Fluttertoast.showToast(
            msg: "Please enter valid login details...",
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
