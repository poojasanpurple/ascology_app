import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/astro_request.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/request/user_update_profile.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:ascology_app/screens/edit_user_profile.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:ascology_app/utility/info_card.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;



class UserProfile extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  String agent_id;

 // AstroDescription({this.agent_id});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = false;
  String got_agent_id;
  List astrologerslist = [];
  List<String> astroimages;
  int activePage = 1;


  PageController _pageController;

  String user_name,user_mobile,user_email,user_gender, session_user_id,user_desc,user_img,
  user_birthdate,user_birthplace,user_time;
  var astro_about;

  final formKey = GlobalKey<FormState>();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  SharedPreferences logindata;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    fetch_user_details();
    
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


  void fetch_user_details() async {
    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    var _loginApiClient = LoginApiClient();
    UserRequestModel model = UserRequestModel();
    model.user_id = session_user_id;
    print(model.user_id);

    UserListingResponse userListingResponse = await _loginApiClient.getprofiledetails(model);

    print("!Q!Q!QQ!Q!Q!Q ${userListingResponse.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (userListingResponse.status == true) {
      print(userListingResponse.data);
      setState(() {
        isLoading = false;
      });

      user_name = userListingResponse.data[0].name.toString();
      user_mobile = userListingResponse.data[0].mobile.toString();
      user_email = userListingResponse.data[0].email.toString();
      user_gender = userListingResponse.data[0].gender.toString();
      user_desc = userListingResponse.data[0].short_description.toString();
      user_img = userListingResponse.data[0].image.toString();

      if(user_img!=null)
      {
        user_img = userListingResponse.data[0].image.toString();
      }
      else
      {
        user_img = '${user_img}';
      }
      user_birthplace = userListingResponse.data[0].place_birth.toString();
      user_birthdate = userListingResponse.data[0].date_birth.toString();
      user_time = userListingResponse.data[0].time.toString();
      //  String a = AstrologerDetails.fromJson(userModel.data).agentname;





      /*  AstrologerDetails details = AstrologerDetails();
          details.agentname = userModel.data.asMap()
*/
    }
    else {
      print(userListingResponse.message);
      isLoading = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return
      WillPopScope(
        onWillPop: () async {
      /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The System Back Button is Deactivated')));*/
      return false;
    },
    child:
    Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Profile', style: TextStyle(
              color: Colors.white,
              fontSize: cf.Size.blockSizeHorizontal * 4,
          ),) ,

          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
             /* Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserHomePage()),
              );*/

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserDashboard()),
              );
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/getnow.png'),
                    fit: BoxFit.fill
                )
            ),
          ),


          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditUerProfile()));

              },
              icon: Icon(Icons.edit),
            ),



          ],),


        body:


        SingleChildScrollView
          (child:
        SafeArea(
          minimum: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[

              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: 150,
                height:150,
                child:
                CachedNetworkImage
                  (imageUrl : "https://astroashram.com/uploads/user/"+user_img,
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Image.asset('assets/images/profile.png'),
                  //Image.asset('assets/images/profile.png'),,
                ),
                /*decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage('https://astroashram.com/uploads/user/${user_img}'),
                      //daee640aaf2738bec6203e1c22e22412.jpg')
                    )
                ),*/
              ),
             /* CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://astroashram.com/uploads/user/${user_img}'),
              ),*/

              Text(
                  '${user_name}',
                style: TextStyle(
                  fontSize: cf.Size.blockSizeHorizontal * 4.5,
                  color: const Color(0xffe22525),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              /* Text(
                "Flutter Developer",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blueGrey[200],
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Open Sans"),
              ),*/
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                ),
              ),

              // we will be creating a new widget name info carrd

              InfoCard(text: 'Mobile : ${user_mobile}', icon: Icons.phone, /*onPressed: () async {}*/),
              InfoCard(text: 'Email : ${user_email}', icon: Icons.mail, /*onPressed: () async {}*/),
              InfoCard(
                  text: 'Problem areas : ${user_desc}',
                  icon: Icons.description,
                  onPressed: () async {}),
              InfoCard(text: 'Gender  : ${user_gender}', icon: Icons.person, onPressed: () async {}),
              InfoCard(text: 'Date of birth : ${user_birthdate}', icon: Icons.calendar_today, onPressed: () async {}),
              InfoCard(text: 'Birth Place : ${user_birthplace}', icon: Icons.location_on, onPressed: () async {}),
              InfoCard(text: 'Birth Time : ${user_time}', icon: Icons.lock_clock, onPressed: () async {}),
            ],
          ),
        ))));
  }


 /* @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Profile'), backgroundColor: const Color(0xffe069c3),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit),
              ),



            ],),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0,),

                *//*    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(60/2),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://asccology.com/uploads/agent/'+user_img)
                            )
                        ),
                      ),
                    ),

                    SizedBox(height: 15.0,),
*//*
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(
                              color: const Color(0xffe22525), // Set border color
                              width: 1.0),   // Set border width
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)), // Set rounded corner radius
                          boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))]  // Make rounded corner of border
                      ),
                      child: Text(user_name.toString()),
                    ),



                    SizedBox(height: 20.0,),

                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(
                              color: const Color(0xffe22525), // Set border color
                              width: 1.0),   // Set border width
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)), // Set rounded corner radius
                          boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))]  // Make rounded corner of border
                      ),
                      child: Text(user_mobile.toString()),
                    ),

                    SizedBox(height: 20.0,),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey,

                          border: Border.all(
                              color: const Color(0xffe22525), // Set border color
                              width: 1.0),   // Set border width
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)), // Set rounded corner radius
                          boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))]  // Make rounded corner of border
                      ),
                      child: Text(user_email.toString()),
                    ),

                    SizedBox(height: 20.0,),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey,

                          border: Border.all(
                              color: const Color(0xffe22525), // Set border color
                              width: 1.0),   // Set border width
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)), // Set rounded corner radius
                          boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,2))] // Make rounded corner of border
                      ),
                      child: Text(user_gender.toString()),
                    ),

                    SizedBox(height: 20.0,),




                    *//* auth.registeredInStatus == Status.Registering
                        ? loading
                        : longButtons("Register", doRegister),
*//*
                    *//* Container(
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
*//*
                   *//* GestureDetector(
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
                          border: Border.all( width: 1,color: const Color(0xffe22525)Accent),
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/getnow.png'),
                              fit: BoxFit.cover
                          ),
                        ), // button text
                        child: Text("Submit", style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.white

                        ),),
                      ),
                    ),*//*


                    SizedBox(height: 20.0,),
                   



                    *//* auth.loggedInStatus == Status.Authenticating
    ?loading
        : longButtons('Register',doRegister)*//*
                  ],
                ),
              ),
            ),
          ),
        )
    );


    // print('data:'+astrologerDetails.)



  }
*/



}

