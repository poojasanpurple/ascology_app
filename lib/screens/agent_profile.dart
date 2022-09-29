import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/astro_request.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:ascology_app/screens/agent_home.dart';
import 'package:ascology_app/screens/edit_agent_profile.dart';
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



class AgentProfile extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  String agent_id;

  // AstroDescription({this.agent_id});

  @override
  _AgentProfileState createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile> {

  bool isLoading = false;
  String got_agent_id;
  List astrologerslist = [];
  List<String> astroimages;
  int activePage = 1;


  PageController _pageController;

  String agent_name,agent_mobile,agent_price,agent_timing, session_agent_id,agent_desc,agent_img;
  String agent_exp,agent_about;
  var astro_about;

  final formKey = GlobalKey<FormState>();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  SharedPreferences logindata;

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    fetch_Agent_details();

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

  void fetch_Agent_details() async {
    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_agent_id = logindata.getString('agent_id');

    var _loginApiClient = LoginApiClient();
    AgentRequestModel model = AgentRequestModel();
    model.agent_id = session_agent_id;
    print(model.toString());

    AstrologerListingResponse listingResponse = await _loginApiClient.getagentprofile(model);

    print("!Q!Q!QQ!Q!Q!Q ${listingResponse.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (listingResponse.status = true) {
      print(listingResponse.data);
      setState(() {
        isLoading = false;
      });

      agent_name = listingResponse.data[0].agentname.toString();
      agent_mobile = listingResponse.data[0].mob.toString();
      agent_price = listingResponse.data[0].price.toString();
      agent_timing = listingResponse.data[0].timing.toString();
      agent_desc = listingResponse.data[0].short_description.toString();
      agent_img = listingResponse.data[0].image.toString();
      agent_exp = listingResponse.data[0].experience.toString();
      agent_about = listingResponse.data[0].about.toString();
      //  String a = AstrologerDetails.fromJson(userModel.data).agentname;


      /*  AstrologerDetails details = AstrologerDetails();
          details.agentname = userModel.data.asMap()
*/
    }
    else {
      print(listingResponse.message);
      isLoading = false;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          title: Text('My Profile', style: TextStyle(
              color: Colors.white,
            fontSize: cf.Size.blockSizeHorizontal * 4,
          ),) ,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AgentHomePage()),
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

                Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditAgentProfile()));



              },
              icon: Icon(Icons.edit),
            ),

          ],),
        body:       WillPopScope(
            onWillPop: () async {
              /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The System Back Button is Deactivated')));*/
              return false;
            },
            child:
        SingleChildScrollView(
            child:

        SafeArea(
          minimum: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[

              /*Center(
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/profile.png',
                  image: agent_img != null?'https://astroashram.com/uploads/agent/'+agent_img : 'assets/images/profile.png',
                ),
              ),*/

             Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: 150,
                  height:150,
                  child:
                  CachedNetworkImage
                    (imageUrl : "https://astroashram.com/uploads/agent/"+agent_img,
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Image.asset('assets/images/profile.png'),
                    //Image.asset('assets/images/profile.png'),,
                  ),
                ),
              ),
              /*CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://astroashram.com/uploads/agent/'+agent_img),
              ),*/
              Text(
                '${agent_name}',
                style: TextStyle(
                  fontSize:  cf.Size.blockSizeHorizontal * 4.5,
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

              InfoCard(text:  'Mobile : ${agent_mobile}', icon: Icons.phone, /*onPressed: () async {}*/),
              InfoCard(text:  'Timing : ${agent_timing}', icon: Icons.lock_clock, /*onPressed: () async {}*/),
              InfoCard(text: 'Experience : '+ '${agent_exp}'+' years', icon: Icons.calendar_today, /*onPressed: () async {}*/),
              InfoCard(text:  'Expertise : ${agent_desc}',
                  icon: Icons.description,
                  onPressed: () async {}),
             // InfoCard(text: agent_about, icon: Icons.info, onPressed: () async {}),
            ],
          ),
        )
    )),);
  }

/*

  @override
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

                       Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(60/2),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://asccology.com/uploads/agent/'+agent_img)
                            )
                        ),
                      ),
                    ),

                    SizedBox(height: 15.0,),

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
                      child: Text(agent_name.toString()),
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
                      child: Text(agent_mobile.toString()),
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
                      child: Text(agent_price.toString()),
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
                      child: Text(agent_timing.toString()),
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
                      child: Text(agent_desc.toString()),
                    ),




                    */
/* auth.registeredInStatus == Status.Registering
                        ? loading
                        : longButtons("Register", doRegister),
*//*

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
*//*

                    */
/* GestureDetector(
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




                    */
/* auth.loggedInStatus == Status.Authenticating
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

