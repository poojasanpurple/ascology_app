import 'dart:async';
import 'dart:io';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/user_register_request.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/login.dart';
import 'package:ascology_app/screens/user_verify_otp.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:ascology_app/global/configFile.dart' as cf;



class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String apkversion = '1.1';
  String reg_email, reg_password, reg_mobile, reg_name, reg_gender, reg_devicename, reg_devmodel, reg_imeinumber,
      reg_dob,reg_birthplace,formattedTime;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController birthplacecontroller = TextEditingController();

  String user_birthdate = "";
  DateTime selectedDate = DateTime.now();

 // var uuid= new Uuid();
 // String _sessionToken = new Uuid();
  List<dynamic>_placeList = [];

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
          deviceVersion = build.version.toString();
          identifier = build.androidId;
        });
       /* Flushbar(
          title: 'Invalid form',
          message: 'details' + deviceName + '' + deviceVersion + ' ' +
              identifier,
          duration: Duration(seconds: 10),
        ).show(context);
*/
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name;
          deviceVersion = data.systemVersion;
          identifier = data.identifierForVendor;
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  /*static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};*/


  final formKey = GlobalKey<FormState>();

  String _selectedGender = 'male';
  String _selectedTime;

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

    _deviceDetails();
    cf.Size.init(context);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('User Registration', style: TextStyle(
                color: Colors.white,
                fontSize: cf.Size.blockSizeHorizontal * 4,
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
                    TextFormField(  style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                      // validator: validateEmail,
                      controller: fullnameController,
    onSaved: (value) => reg_name = value,
                      decoration: buildInputDecoration("Enter Name", Icons.person),

                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      //  validator: validateEmail,
                      onSaved: (value) => reg_email = value,
                      controller: emailController,
                      decoration: buildInputDecoration("Enter Email", Icons
                          .email),
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      obscureText: true,
                       validator: (value)=>value.isEmpty?'Please enter password':null,
    onSaved: (value) => reg_password = value,
                      decoration: buildInputDecoration(
                              "Enter Password", Icons.lock),
                      controller: passwordController,
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      keyboardType: TextInputType.number,

                      maxLength: 10,
                      onSaved: (value) => reg_mobile = value,
                      decoration: buildInputDecoration(
                          "Enter mobile number", Icons.phone),
                      controller: mobilenoController,
                    ),
                    SizedBox(height: 20.0,),

                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      onSaved: (value) => reg_dob = value,
                      decoration: buildInputDecoration(
                          "Enter date of birth", Icons.calendar_today),
                      controller: dobcontroller,
                      onTap: ()
                      {
                        _selectDate(context);
                      },
                    ),



                    /*  Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text("Select Date of Birth"),
                        ),

                        SizedBox(width: 5.0),

                        Text("${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                      ],
                    ),*/

                    SizedBox(height: 20.0,),

                 /*   Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showtime(context);
                          },
                          child: Text("Select time of birth"),
                        ),

                        SizedBox(width: 5.0),

                        Text(_selectedTime != null ? _selectedTime : 'No time selected!'),
                      ],
                    ),*/

                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      onSaved: (value) => formattedTime = value,
                      decoration: buildInputDecoration(
                          "Enter time of birth", Icons.lock_clock),
                      controller: timecontroller,
                      onTap: ()
                      {
                        _showtime(context);
                      },
                    ),



                    SizedBox(height: 20.0,),

                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,

                      onSaved: (value) => reg_birthplace = value,
                      onTap: () async
                      {
                        showGooglePlaceWidget();
                       // displayPrediction(p);
                      },
                      validator: (val) =>
                      val.isEmpty ? 'Enter birth place' : null,
                      onChanged: (val) async {
                        setState(() => reg_birthplace = val);

                      },
                      decoration: buildInputDecoration(
                          "Enter birth place", Icons.location_on),
                      controller: birthplacecontroller,
                    ),
                    SizedBox(height: 10.0,),

                    Text('Select Gender',  style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 10.0,),

                    ListTile(
                      leading: Radio<String>(
                        value: 'Male',
                        groupValue: reg_gender,
                        onChanged: (value) {
                          setState(() {
                            reg_gender = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      title:  Text('Male',  style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),),
                    ),
                    ListTile(
                      leading: Radio<String>(
                        value: 'Female',
                        groupValue: reg_gender,
                        onChanged: (value) {
                          setState(() {
                            reg_gender = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      title:  Text('Female',  style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),),
                    ),
                   /* auth.registeredInStatus == Status.Registering
                        ? loading
                        : longButtons("Register", doRegister),
*/
                     /* Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ElevatedButton(
                            child: Text("Submit",
                              style: TextStyle(fontWeight: FontWeight.w300),),
                            onPressed: () {
                              // Navigator.pushReplacementNamed(context, '/login');
                             // doregister();
                            //  _deviceDetails();
                              user_register(context);

                            },
                          ),

                        ),
*/
                    GestureDetector(
                      onTap: () {
                        user_register(context);
                        //print('do something');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.fromLTRB(
                            50.0, 30, 50.0, 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all( width: 1,color: const Color(0xffe22525)),
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/getnow.png'),
                              fit: BoxFit.cover
                          ),
                        ), // button text
                        child: Text("Submit", style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: cf.Size.blockSizeHorizontal * 3.5,
                            color: Colors.white

                        ),),
                      ),
                    ),


                    SizedBox(height: 20.0,),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),

                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Already have account? ',
                            style: TextStyle(
                              fontSize : cf.Size.blockSizeHorizontal * 3.8,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.black,
                                  fontSize : cf.Size.blockSizeHorizontal * 3.8,
                                fontWeight: FontWeight.bold
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
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
                                size: 30,
                                color: const Color(0xffe22525),
                                //  Icons.facebook
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: ImageIcon(
                                AssetImage('assets/images/twitter.png'),
                                size: 30,
                                color: const Color(0xffe22525),

                                //  Icons.facebook
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: ImageIcon(
                                AssetImage('assets/images/instagram.png'),
                                size: 30,
                                color: const Color(0xffe22525),

                                //  Icons.facebook
                              ),
                              onPressed: () {},
                            ),
                          ]),
                    ),*/


                    /* auth.loggedInStatus == Status.Authenticating
    ?loading
        : longButtons('Register',doRegister)*/
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Future showGooglePlaceWidget() async {
    // Prediction p = await PlacesAutocomplete.show(
    var place = await PlacesAutocomplete.show(

        context: context,
        apiKey: "AIzaSyC54_RnAsutpoao87j9w-OmbawLMdKA1jo",
        mode: Mode.overlay,
        language: "en",
        radius: 10000000 == null ? null : 10000000

    );

    setState(() {
      reg_birthplace = place.description.toString();
      birthplacecontroller.text = reg_birthplace;

      //getlatlong(birth_location);


    });

  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;

      //  reg_dob = ' ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
        reg_dob = DateFormat("yyyy-MM-dd").format(selectedDate);


        dobcontroller.text = reg_dob;
      });
  }

  Future<void> _showtime(BuildContext context) async {
    final TimeOfDay result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {

        DateTime parsedTime = DateFormat.jm().parse(result.format(context).toString());
        //converting to DateTime so that we can further format on different pattern.
        print(parsedTime); //output 1970-01-01 22:53:00.000
        formattedTime = DateFormat('HH:mm').format(parsedTime);
        print(formattedTime); //output 14:59:00
        /* _selectedTime = result.format(context);

        finaltime = DateFormat('HH:mm').format(_selectedTime);*/
        timecontroller.text = formattedTime;
      });
    }
  }

  void user_register(BuildContext context) async{

     reg_name = fullnameController.text;
     reg_mobile = mobilenoController.text;
     reg_email = emailController.text;
     reg_password = passwordController.text;
     reg_dob = dobcontroller.text;
     reg_birthplace = birthplacecontroller.text;
    // UserForgetPasswordResponseModel

   // print("phoneNumber.length ${phoneNumber.length}");
    if(reg_name != null && reg_name != ""){
      if(reg_mobile != null && reg_mobile.length == 10){
        if(reg_email != null && reg_email != ""){
          //bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(reg_email);
          bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(reg_email);
          if(emailValid) {
            if (reg_password != null && reg_password != '') {
              if ((reg_birthplace != null && reg_birthplace != '') &&
                  (reg_dob != null && reg_dob != '') &&
                  (formattedTime != null && formattedTime != '') && (reg_gender!=null && reg_gender!=''))
                {
                var _loginApiClient = LoginApiClient();
              UserRegisterRequestModel registerRequestModel = new UserRegisterRequestModel();

              registerRequestModel.name = reg_name;
              registerRequestModel.mobile = reg_mobile;
              registerRequestModel.email = reg_email;
              registerRequestModel.password = reg_password;
              registerRequestModel.gender = reg_gender;
              registerRequestModel.device_name = '';
              registerRequestModel.device_model = '';
              registerRequestModel.apk_version = '';
              registerRequestModel.imei_number = '';
              registerRequestModel.date_birth = reg_dob;
              registerRequestModel.place_birth = reg_birthplace;
              registerRequestModel.time = formattedTime;
              UserForgetPasswordResponseModel registerResModel = await _loginApiClient
                  .registerUser(registerRequestModel);



              if (registerResModel.status == true) {
                Fluttertoast.showToast(
                    msg: "OTP sent to your mobile...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: cf.Size.blockSizeHorizontal * 4,
                );

                // openSubscriptionPage(context, registerResModel);

                /*  Flushbar(
                     // title: 'Invalid form',
                      message: registerResModel.message,
                      duration: Duration(seconds: 5),
                    ).show(context);
*/
                //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UserVerifyOtp(
                            mobile: reg_mobile, usertype: "User");
                      },
                    ));
              }
              else {
                //loaderFun(context, false);
                //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Unable to create account.')));

                Fluttertoast.showToast(
                    msg: registerResModel.message,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: cf.Size.blockSizeHorizontal * 4,
                );
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);

              }
            }
            else {
                Fluttertoast.showToast(
                    msg: "Please enter your birth details...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize:cf.Size.blockSizeHorizontal * 4,
                );

            }
          }
            else{

              Fluttertoast.showToast(
                  msg: "Please enter your password...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                fontSize:cf.Size.blockSizeHorizontal * 4,
              );
              /* loaderFun(context, false);
              _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter your password.')));*/
            }
          }
          else{
          /*  loaderFun(context, false);
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter valid Email ID.')));*/
            Fluttertoast.showToast(
                msg: "Please enter valid email id...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
              fontSize:cf.Size.blockSizeHorizontal * 4,
            );
          }
        }
        else{
          Fluttertoast.showToast(
              msg: "Please enter your email id...",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            fontSize:cf.Size.blockSizeHorizontal * 4,
          );
         /* loaderFun(context, false);
          _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter your Email Id.')));*/
        }
      }else{
        Fluttertoast.showToast(
            msg: "Please enter valid phone number...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          fontSize:cf.Size.blockSizeHorizontal * 4,
        );
       /* loaderFun(context, false);
        _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter valid phone number.')));*/
      }
    }
    else{
      Fluttertoast.showToast(
          msg: "Please  enter your full name...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        fontSize:cf.Size.blockSizeHorizontal * 4,
      );
      /*loaderFun(context, false);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter your full name')));*/
    }
  }

}