

import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/contact_request.dart';
import 'package:ascology_app/model/response/agent_register_response.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:internet_connection_checker/internet_connection_checker.dart';


class ContactUsPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String contact_name, contact_subject,contact_email,contact_phone,contact_message;

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

    cf.Size.init(context);
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Contact Us', style: TextStyle(
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
          body:

    SingleChildScrollView(
    child:
          Column(
         //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [


              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Contact Info',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 4,color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.bold)),
              ),

                  ListTile(
                    leading: Icon(Icons.location_on_rounded,color: const Color(0xffe22525), size: 30),
                    title: Text(
                        'Location',
                        style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.grey,fontFamily: 'Poppins',fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(
                        'Second Floor 69/6A Rama Road Najafgarh road Delhi 110015 India',
                        style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')
                    ),
                  ),

              ListTile(
                leading: Icon(Icons.call,color: const Color(0xffe22525), size: 30),
                title: Text(
                    'Call Us',
                    style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.grey,fontFamily: 'Poppins',fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                    '7390002000 \n01161200500',
                    style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')
                ),
              ),

              ListTile(
                leading: Icon(Icons.email,color: const Color(0xffe22525), size: 30),
                title: Text(
                    'Mail Us',
                    style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.grey,fontFamily: 'Poppins',fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                    'support@asccology.com',
                    style: TextStyle(fontSize:cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')
                ),
              ),

              ListTile(
                leading: Icon(Icons.timer,color: const Color(0xffe22525), size: 30),
                title: Text(
                    'Office Hour',
                    style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.grey,fontFamily: 'Poppins',fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                    'Monday - Friday (9.00-19.00) \nSunday - Thursday (10.00-06.00)',
                    style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins'),maxLines: 2,
                ),
              ),

          Container(
            /*  width: 300,
              height:100,*/
            margin: EdgeInsets.all(20.0),
              decoration:BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    width: 1.0,
                    color: const Color(0xffe22525),
                  )
              ),

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Contact Form',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.8,color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.bold)),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(30.0,20,30.0,0),
                    alignment: Alignment.center,
                    child: TextFormField(
                      autofocus: false,
                      style: TextStyle(color: Colors.black,fontSize: cf.Size.blockSizeHorizontal * 3.2),
                      //validator: validateEmail,
                    //  keyboardType: TextInputType.number,
                      controller: nameController,
                      onSaved: (value) => contact_name = value,
                      decoration: buildInputDecoration(
                          'Your Name', Icons.person),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(30.0,20,30.0,0),
                    alignment: Alignment.center,
                    child: TextFormField(
                      autofocus: false,
                      style: TextStyle(color: Colors.black,fontSize: cf.Size.blockSizeHorizontal * 3.2),
                      //validator: validateEmail,
                     // keyboardType: TextInputType.number,
                      controller: subjectController,
                      onSaved: (value) => contact_subject = value,
                      decoration: buildInputDecoration(
                          'Your Subject', Icons.subject),
                    ),
                  ),



                  Container(
                    margin: EdgeInsets.fromLTRB(30.0,20,30.0,0),

                    alignment: Alignment.center,
                    child: TextFormField(
                      autofocus: false,
                      style: TextStyle(color: Colors.black,fontSize: cf.Size.blockSizeHorizontal * 3.2),
                      //validator: validateEmail,
                      controller: emailController,

                      onSaved: (value) => contact_email = value,
                      decoration: buildInputDecoration(
                          'Your Email', Icons.email),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(30.0,20,30.0,0),

                    alignment: Alignment.center,
                    child: TextFormField(
                      autofocus: false,
                      style: TextStyle(color: Colors.black,fontSize: cf.Size.blockSizeHorizontal * 3.2),
                      //validator: validateEmail,
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      maxLength: 10,
                      onSaved: (value) => contact_phone = value,
                      decoration: buildInputDecoration(
                          'Your Phone', Icons.call),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(30.0,20,30.0,0),

                    alignment: Alignment.center,
                    child: TextFormField(
                      autofocus: false,
                      style: TextStyle(color: Colors.black,fontSize: cf.Size.blockSizeHorizontal * 3.2),
                      //validator: validateEmail,
                     // keyboardType: TextInputType.number,
                      controller: messageController,
                      maxLines: 6,
                      onSaved: (value) => contact_message = value,
                      decoration: buildInputDecoration(
                          'Your Message', Icons.message),
                    ),
                  ),



                  GestureDetector(
                    onTap: () {
                     /* Fluttertoast.showToast(
                          msg: "Sending message...",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );*/
                    submitcontactform(context);
                      //print('do something');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(
                          40.0, 20, 40.0, 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all( width: 1,color: const Color(0xffe22525)),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/getnow.png'),
                            fit: BoxFit.cover
                        ),
                      ), // button text
                      child: Text("Submit Message", style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize:cf.Size.blockSizeHorizontal * 3.2,
                          color: Colors.white

                      ),),
                    ),
                  ),
                ],
              ),

    ),

            ],

          ),
    ),



                ),
              );



  }

  void submitcontactform(BuildContext context) async {
    contact_name = nameController.text;
    contact_subject = subjectController.text;
    contact_email = emailController.text;
    contact_phone = phoneController.text;
    contact_message = messageController.text;

    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(contact_email);

    if (contact_phone.length == 10 && contact_phone!= '' && contact_name!='' && contact_subject!='' && contact_email!=''
        && contact_message!='' && emailValid== true) {

      //  loaderFun(context, true);
      var _loginApiClient = LoginApiClient();
      ContactRequestModel contactRequestModel = ContactRequestModel();
      contactRequestModel.name = contact_name;
      contactRequestModel.email = contact_email;
      contactRequestModel.mobile = contact_phone;
      contactRequestModel.message = contact_message;
      contactRequestModel.subject = contact_subject;

      AgentRegisterResponseModel userModel =
      await _loginApiClient.submitcontact(contactRequestModel);

      print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
      // (data?.isEmpty ?? true
      //  if (userModel?.status ?? true) {
      //   if (userModel!=null) {
      //  if (userModel.status == true) {
      if (userModel.status = true) {
        print('Sent successfully');
        Fluttertoast.showToast(
            msg: "Message sent successfully...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

         nameController.text = '';
        subjectController.text = '';
        emailController.text  = '';
       phoneController.text = '';
        messageController.text = '';


        /*  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );*/
      }
      else {
        Fluttertoast.showToast(
            msg: "Message sending failed...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

    }

    else
    {
      Fluttertoast.showToast(
          msg: "Please enter all valid details...",
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