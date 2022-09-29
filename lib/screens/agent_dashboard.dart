
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_login_request.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/delete_queue_agentrequest.dart';
import 'package:ascology_app/model/request/get_status_request.dart';
import 'package:ascology_app/model/request/update_status_request.dart';
import 'package:ascology_app/model/request/user_feedback_request.dart';
import 'package:ascology_app/model/response/agent_login_response.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/feedback_response.dart';
import 'package:ascology_app/model/response/get_status_response.dart';
import 'package:ascology_app/model/response/testimonal_response.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/agent_chat.dart';
import 'package:ascology_app/screens/agent_chat_history.dart';
import 'package:ascology_app/screens/agent_followers.dart';
import 'package:ascology_app/screens/agent_login.dart';
import 'package:ascology_app/screens/agent_profile_home.dart';
import 'package:ascology_app/screens/agent_review.dart';
import 'package:ascology_app/screens/agent_upload_video.dart';
import 'package:ascology_app/screens/basic_panchang.dart';
import 'package:ascology_app/screens/birth_details.dart';
import 'package:ascology_app/screens/daily_horoscope_page.dart';
import 'package:ascology_app/screens/horoscope.dart';
import 'package:ascology_app/screens/about_us.dart';
import 'package:ascology_app/screens/agent_call_history.dart';
import 'package:ascology_app/screens/agent_profile.dart';
import 'package:ascology_app/screens/agent_register.dart';
import 'package:ascology_app/screens/astrologer_desc_page.dart';
import 'package:ascology_app/screens/astrologers.dart';
import 'package:ascology_app/screens/blogs_page.dart';
import 'package:ascology_app/screens/chat_detail.dart';
import 'package:ascology_app/screens/client_testimonals.dart';
import 'package:ascology_app/screens/contact_us.dart';
import 'package:ascology_app/screens/kundali_match.dart';
import 'package:ascology_app/screens/login.dart';
import 'package:ascology_app/screens/membership.dart';
import 'package:ascology_app/screens/privacy_policy.dart';
import 'package:ascology_app/screens/rate_us_page.dart';
import 'package:ascology_app/screens/refer_earn.dart';
import 'package:ascology_app/screens/upload_gallery_images.dart';
import 'package:ascology_app/screens/user_gallery.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:ascology_app/screens/user_profile.dart';
import 'package:ascology_app/screens/user_services.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import 'package:flutter_share_me/flutter_share_me.dart';

import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AgentDashboard extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentDashboardState createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {

  final formKey = GlobalKey<FormState>();
  bool isSwitched_chat;
  bool isSwitched_call;
  bool isSwitched_emer;
  var imgforupload;
  List<Asset> selectedimageslist = List<Asset>();
  List astrologerslist = [];
  List searchlist = [];
  bool isLoading = false;

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  // List<AstrologerDetails> dataFromServer = List();

  String agent_call_status, agent_chat_status, agent_emer_status;
  String user_email,feedback_rating,agent_extension, call_status,chat_status,status_type,status_call,status_chat;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController feedbackdesccontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();
  String searchText="";
  String formatter = DateFormat("yyyy-MM-dd").format(DateTime.now());// 28/03/2020

  //List<AstrologerDetails> astrologerlist = List();
  List<AstrologerListingResponse> astrologerlist = List();
  List<TestimonalResponse> testmonallist = List();
  List<AstrologerDetails> newastrolist = List();
  AstrologerListingResponse _astrologerListingResponse;

  SharedPreferences logindata;
  String session_agent_id,feedback_desc,search_value,session_agent_mobile,session_agent_password;
  Future <List<AstrologerListingResponse>> futureData;
  File _image;


  Future<bool> _onWillPop(BuildContext context) async {
    bool exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }


  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    );
  }



  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    getConnectivity();
    //  getnewstrolist();
  //  fetchUser();
    // futureData = getnewstrolist();
    getsession_userid();
 //   checkuserexists(context);

    fetch_Agent_details();
    /*Future.delayed(Duration(seconds: 2), (){
      print("Executed after 5 seconds");


    });*/
    //getchatcount();
   /* getallstatus_call();
    getallstatus_chat();*/

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

  void checkuserexists(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();

          //  loaderFun(context, true);
          var _loginApiClient = LoginApiClient();
          AgentLoginRequestModel loginRequestModel = new AgentLoginRequestModel();
          loginRequestModel.phone = session_agent_mobile;
          loginRequestModel.password = session_agent_password;
          //  loginRequestModel.token = '';
          loginRequestModel.device_name = '';
          loginRequestModel.device_model = '';
          loginRequestModel.apk_version = '';
          loginRequestModel.imei_number = '';

          AgentLoginResponseModel userModel = await _loginApiClient.agentlogin(loginRequestModel);
          print("!Q!Q!QQ!Q!Q!Q $userModel");
          if(userModel.status == true){



          }
          else
          {
            //  loaderFun(context, false);
            Fluttertoast.showToast(
                msg: "Invalid login details...Please check your login credentials",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: cf.Size.blockSizeHorizontal*3.5
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  AgentLogin()),
            );
            print('Account does not exist');
          }


  }


  void getchatcount() async {


  }


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
    if (listingResponse.status == true) {
      print(listingResponse.data);
      setState(() {
        isLoading = false;
      });

      agent_call_status = listingResponse.data[0].PhoneCallStatus.toString();
      agent_chat_status = listingResponse.data[0].ChatStatus.toString();
      agent_emer_status = listingResponse.data[0].EmergencyCallStatus.toString();

      //  String a = AstrologerDetails.fromJson(userModel.data).agentname;
      setState(() {
        if(agent_call_status=="0")
        {
          isSwitched_call = false;
        }
        else if(agent_call_status == "1")
        {
          isSwitched_call = true;
        }

        if(agent_chat_status =="0")
        {
          isSwitched_chat = false;
        }
        else if(agent_chat_status == "1")
        {
          isSwitched_chat = true;
        }


        if(agent_emer_status =="0")
        {
          isSwitched_emer = false;
        }
        else if(agent_emer_status == "1")
        {
          isSwitched_emer = true;
        }



      });

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
   // return SafeArea(
    cf.Size.init(context);


    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
          resizeToAvoidBottomInset:false,
          appBar:AppBar(
            title: Text('Dashboard', style: TextStyle(
                color: Colors.white,
                fontSize:cf.Size.blockSizeHorizontal * 4.5, fontFamily: 'Poppins'
            ),) ,

            flexibleSpace: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/getnow.png'),
                      fit: BoxFit.fill
                  )
              ),
            ),


            actions: [
             /* IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/wallet.png'),
              ),*/

              PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                  itemBuilder: (context){
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("My Profile",style: TextStyle(
                            fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3

                          //  fontSize: 36.0,
                        ),),
                      ),

                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Call History",style: TextStyle(
                            fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3

                          //  fontSize: 36.0,
                        ),),
                      ),

                      PopupMenuItem<int>(
                        value: 3,
                        child: Text("Chat History",style: TextStyle(
                            fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3

                          //  fontSize: 36.0,
                        ),),
                      ),

                      PopupMenuItem<int>(
                        value: 2,
                        child: Text("Logout",style: TextStyle(
                            fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3
                        ),
                        ),
                      ),
                    ];
                  },
                  onSelected:(value){
                    if(value == 0){
                      print("My account menu is selected.");

                      Navigator.push(context,new MaterialPageRoute(builder:
                          (context) => AgentProfile()));

                    }
                    else if(value == 1){


                      Navigator.push(context,new MaterialPageRoute(builder:
                          (context) => AgentCallHistory()));

                    }else if(value == 2){
                      print("Logout menu is selected.");

                      logindata.setBool('agentlogin', true);
                      logindata.setString('user_type', '');
                      logindata.setString('agent_id', '');
                      logindata.setString('agent_ext', '');
                      sendtodelete_queue(context);

                   /*   Navigator.pushReplacement(context,new MaterialPageRoute(builder:
                          (context) => Login()));

*/

                    }

                    else if(value == 3){


                      Navigator.push(context,new MaterialPageRoute(builder:
                          (context) => AgentChatHistory()));

                    }
                  }
              ),


            ],),

          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      /*image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/logo.png'))*/
                    ),
                    child: Center(
                      child: Text(
                        'ASTROASHRAM',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*4,overflow: TextOverflow.ellipsis),
                      ),
                    )),
                ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/homesidemenu.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () { Navigator.pop(context);}, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title:  Text('Home',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                  onTap: () {

                    Navigator.pop(context);
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AgentDashboard()),
                    );*/
                  },
                ),

                const Divider(),

              /*  ListTile(
                  leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/aboutus.png'),radius: 15),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title: const Text('About Us'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUsPage()),
                    );
                  },
                ),
                const Divider(),*/

                ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/gallery.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryPage()),
                      );
                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title:  Text('Gallery',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GalleryPage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/contacts.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactUsPage()),
                        );
                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title:  Text('Contact Us',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsPage()),
                    );
                  },
                ),
                const Divider(),

                //  asccology@1000
              /*  ListTile(
                  leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/blogs.png'),radius: 15),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlogsPage()),
                        );
                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title: const Text('Blogs'),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlogsPage()),
                    );
                  },
                ),
                const Divider(),*/

                ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/horoscope.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HoroscopePage()),
                        );
                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title:  Text('Horoscope',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HoroscopePage()),
                    );
                  },
                ),
                const Divider(),


             /*   ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/horoscope.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RateUsPage()),
                        );
                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title: const Text('Rate Us'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RateUsPage()),
                    );
                  },
                ),
                const Divider(),*/

               /* ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/horoscope.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReferEarnPage()),
                        );
                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title: const Text('Refer And Earn'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReferEarnPage()),
                    );
                  },
                ),
                const Divider(),*/

                ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/horoscope.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () async{
                        await Share.share('Check the below link for more information on astrology. https://astroashram.com/ ');

                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title:  Text('Share',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                  onTap: () async{
                    //shareonwhatsapp();

                    await Share.share('Check the below link for more information on astrology. https://astroashram.com/ ');

                    // Navigator.pop(context);
                  },
                ),
                const Divider(),

                ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/horoscope.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () async{
                        logindata.setBool('agentlogin', true);
                        logindata.setString('user_type', '');
                        logindata.setString('agent_id', '');
                        logindata.setString('agent_ext', '');
                        sendtodelete_queue(context);

                      }, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
                  ),
                  title:  Text('Logout',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                  onTap: () async{
                    //shareonwhatsapp();
                    logindata.setBool('agentlogin', true);
                    logindata.setString('user_type', '');
                    logindata.setString('agent_id', '');
                    logindata.setString('agent_ext', '');
                    sendtodelete_queue(context);

                    // Navigator.pop(context);
                  },
                ),
                const Divider(),

                ListTile(
                  leading: SizedBox(
                      height: 30.0,
                      width: 30.0, // fixed width and height
                      child: Image.asset('assets/images/horoscope.png')
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () async {

                        Navigator.push(
                            context, new MaterialPageRoute(builder:
                            (context) => PrivPolicyPage()));
                      },
                          icon: Icon(Icons.arrow_forward_ios_outlined),
                          color: Colors.red),
                    ],
                  ),
                  title:  Text('Privacy Policy',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                  onTap: () {
                    //shareonwhatsapp();

                    Navigator.push(
                        context, new MaterialPageRoute(builder:
                        (context) => PrivPolicyPage()));

                    // Navigator.pop(context);
                  },
                ),
                const Divider(),
              ],
            ),
          ),

          body: SingleChildScrollView(
            child:


            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              //  height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.
              //width: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child:
              //  padding: EdgeInsets.all(20),
              /*Flex( direction: Axis.vertical,
              children: [
              Expanded(*/
            /*  Flexible(
                child:*/
                Column(
                  children: [
                    /*Text(
    _astrologerListingResponse.message,
    style: TextStyle(fontSize: 20),
    ),*/
/*

                    TextFormField(

                      autofocus: false,
                      style: TextStyle(color: Colors.black,fontFamily: 'Poppins'),

                      validator: (value) =>
                      value.isEmpty ? "Search" : null,
                      onSaved: (value) => search_value = value,
                      controller: searchcontroller,
                      decoration:
                      buildInputDecoration('Search', Icons.search),
                    ),
*/


                   // SizedBox(height: 20),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            IconButton(
                              // minWidth: 25.0,
                              iconSize: 70,
                              icon: Image.asset('assets/images/dailyhoroscope.png'),
                              /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),*/
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DailyHoroscopePage()),
                                );
                              },
                            ),
                            Text('Daily Horoscope',textAlign: TextAlign.center, style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: cf.Size.blockSizeHorizontal*2.3,
                                fontFamily: 'Poppins'))
                          ],),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              // minWidth: 25.0,
                              iconSize: 70,

                              icon: Image.asset('assets/images/freekundali.png'),
                              /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),*/
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BirthDetails()),
                                );

                              },
                            ),
                            Text('Free Kundali',textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: cf.Size.blockSizeHorizontal*2.3,
                                    fontFamily: 'Poppins'))
                          ],
                        ),


                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              // minWidth: 25.0,
                              iconSize: 70,
                              icon: Image.asset('assets/images/kundalimatch.png'),
                              /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),*/
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KundaliMatchMakingPage()),
                                );

                              },
                            ),
                            Text('Kundali Match', textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: cf.Size.blockSizeHorizontal*2.3,
                                    fontFamily: 'Poppins'))
                          ],),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              // minWidth: 25.0,
                              iconSize: 70,
                              icon: Image.asset('assets/images/panchang.png'),
                              /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),*/
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PanchangPage()),
                                );

                              },
                            ),
                            Text('Panchang',textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: cf.Size.blockSizeHorizontal*2.3,
                                    fontFamily: 'Poppins'))
                          ],),
                      ],
                    ),

                    SizedBox(height: 20),

                    Container(
                      // padding: EdgeInsets.all(20),


                      child:


                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: EdgeInsets.all(10.0),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child:
                        Stack(
                            children:<Widget> [

                              Image.asset(
                                'assets/images/wishbackimg.png',
                                fit: BoxFit.cover,
                              ),



                              Padding(
                                padding: const EdgeInsets.fromLTRB(95,20,20,0),
                                child: Text( 'Wishing someone special to be with you forever?',textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: cf.Size.blockSizeHorizontal*3.2,
                                      color: Colors.white,
                                      fontFamily: 'Poppins'),),
                              ),





                            ]),
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.black),
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(child:Text('Type', style: TextStyle(
                                  fontSize: cf.Size.blockSizeHorizontal*3.2,
                                  fontFamily: 'Poppins'),)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(child:Text('Status',style: TextStyle(
                                  fontSize: cf.Size.blockSizeHorizontal*3.2,
                                  fontFamily: 'Poppins'))),
                            )
                           /* Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Next Online Time',textAlign: TextAlign.center),
                            ),*/
                          ]),
                          TableRow(children: [
                            Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(child: Text('Chat',textAlign: TextAlign.center,style: TextStyle(
                                    fontSize: cf.Size.blockSizeHorizontal*3.2,
                                    fontFamily: 'Poppins')),
                                )) ,
                            Switch(
                              value: isSwitched_chat,
                            //  inactiveTrackColor: Colors.grey ,
                              activeColor: const Color(0xffbf2044),
                              onChanged: (value) {

                                setState(() {
                                  isSwitched_chat = value;
                                  status_type = 'Chat';
                                  if(isSwitched_chat == true)
                                    {

                                      chat_status = 'On';
                                    }else
                                      {

                                        chat_status = 'Off';
                                      }

                                  update_status();
                                  print('isSwitched_chat'+isSwitched_chat.toString());
                                });
                              },
                            ),
                           /* Text(''),*/
                          ]),

                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(child: Text('Call',textAlign: TextAlign.center,style: TextStyle(
                                  fontSize: cf.Size.blockSizeHorizontal*3.2,
                                  fontFamily: 'Poppins')),
                            )) ,
                            Center(
                              child:
                            Switch(
                              value: isSwitched_call,
                            //  inactiveTrackColor: Colors.grey ,
                              activeColor: const Color(0xffbf2044),
                              onChanged: (value) {
                                setState(() {
                                  isSwitched_call = value;
                                  status_type = 'Call';
                                  if(isSwitched_call == true)
                                  {

                                    call_status = 'On';
                                  }else
                                  {

                                    call_status = 'Off';
                                  }

                                  update_status();
                                  print('isSwitched_call'+isSwitched_call.toString());
                                });
                              },
                            ),
                            ),
                            //Text(''),
                          ]),

                         /* TableRow(children: [
                            Center(child: Text('Emergency Call',textAlign: TextAlign.center)) ,
                            Center(
                              child:
                              Switch(
                                value: isSwitched_emer,
                                //  inactiveTrackColor: Colors.grey ,
                                activeColor: const Color(0xffbf2044),
                                onChanged: (value) {
                                  setState(() {


                                    update_status();
                                    print('isSwitched_emer'+isSwitched_emer.toString());
                                  });
                                },
                              ),
                            ),
                            Text('Call/Chat'),
                          ])*/
                        ],
                      ),
                    ),


                Container(

                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 400,
                  width:double.infinity,
                  child:
                    /*  Expanded(
                        child:*/
                    GridView(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 13,

                        mainAxisSpacing: 5,
                      ),
                      children: [

                        GestureDetector(
                        onTap: () =>
                        {
                        Navigator.push(context,
                        MaterialPageRoute(
                        builder: (context) {
                        return AgentCallHistory();
                        },
                        ))
                        },
                        child:
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child:Text("CALL", style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*3.5,fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),textAlign: TextAlign.center)),
                        ),
                        ),

                  GestureDetector(
                    onTap: () =>
                    {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AgentChat();
                            },
                          ))
                    },
                    child:
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                         Text("CHAT", style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*3.5,fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),textAlign: TextAlign.center)
                               //Text("", style: TextStyle(color: Colors.white,fontSize: 8),textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                  ),
                       /* Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("WAITLIST", style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center)),
                        ),*/
                      /*  Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("CUSTOMER CARE", style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center)),
                        ),*/
                      /*  Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("WALLET", style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center)),
                        ),*/

                  GestureDetector(
                    onTap: () =>
                    {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AgentReview();
                            },
                          ))

                    },
                    child:

                    Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("REVIEWS", style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*3.5,fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),textAlign: TextAlign.center)),
                        ),
                  ),
                  GestureDetector(
                    onTap: () =>
                    {
                    Navigator.push(context,
                    MaterialPageRoute(
                    builder: (context) {
                    return AgentFollowers();
                    },
                    ))
                    },
                    child:

                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("FOLLOWERS", style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*3,fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),textAlign: TextAlign.center)),
                        ),
              ),

                  GestureDetector(
                    onTap: () =>
                    {
                    Navigator.push(context,new MaterialPageRoute(builder:
                    (context) => AgentProfile()))
                    },
                    child:
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("PROFILE", style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*3.5,fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),textAlign: TextAlign.center)),
                        ),
                  ),
                       /* Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("SETTINGS", style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.center)),
                        ),
*/
                  GestureDetector(
                    onTap: () =>
                    {
                      Navigator.push(context,new MaterialPageRoute(builder:
                          (context) => AgentUploadImages()))
                    },
                    child:
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("ADD IMAGES", style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*3.2,fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),textAlign: TextAlign.center)),
                        ),
                  ),

                  GestureDetector(
                    onTap: () =>
                    {
                      Navigator.push(context,new MaterialPageRoute(builder:
                          (context) => AgentUploadVideo()))
                    },
                    child:
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xffbf2044),
                          child: Center(child: Text("ADD VIDEOS", style: TextStyle(color: Colors.white, fontSize: cf.Size.blockSizeHorizontal*3.3,fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),textAlign: TextAlign.center)),
                        ),
                  ),
                      ],
                    ),
                    //  ),
                ),
                    /* SizedBox(height: 20),

                Container(
                  child: Text('Live Astrologers', textAlign: TextAlign.start, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20)),

                ),
*/

                    Container(
                      color: Colors.black12,
                      child:
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child:Text('Why Astroashram?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: cf.Size.blockSizeHorizontal*4,
                                          fontFamily: 'Poppins')),
                                ),

                              ]
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly,
                              children: <Widget>[

                                Expanded(child:
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    IconButton(
                                      // minWidth: 25.0,
                                      iconSize: 70,
                                      icon: Image.asset(
                                          'assets/images/astrologers.png'),
                                      /* shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),*/
                                      onPressed: () {


                                      },
                                    ),
                                    Text('Verified Astrologers',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: cf.Size.blockSizeHorizontal*3.2,
                                          fontFamily: 'Poppins'),
                                      maxLines: 2,)
                                  ],),
                                ),


                                Expanded(child:
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      // minWidth: 25.0,
                                      iconSize: 70,
                                      icon: Image.asset(
                                          'assets/images/astrologers.png'),
                                      /* shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),*/
                                      onPressed: () {

                                      },
                                    ),
                                    Text('Verified Psychologists',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: cf.Size.blockSizeHorizontal*3.2,
                                          fontFamily: 'Poppins'),
                                      maxLines: 2,)
                                  ],),
                                ),


                                Expanded(child:
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      // minWidth: 25.0,
                                      iconSize: 70,
                                      icon: Image.asset(
                                          'assets/images/blogs.png'),
                                      /* shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),*/
                                      onPressed: () {

                                      },
                                    ),

                                    Text(' 100 % '+'\n'+' Guarantee' ,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: cf.Size.blockSizeHorizontal*3.2,
                                          fontFamily: 'Poppins'),
                                      maxLines: 2,)
                                  ],),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),

                  /*  Container(
                      color: Colors.blueAccent,

                      child:f

                      Card( shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                        color: Colors.white,
                        elevation: 10,
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //  mainAxisSize: MainAxisSize.max,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children:<Widget>[
                                  Container(
                                    child: Text(
                                      'Feedback To The SEO Office',textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: 'Poppins'),

                                    ),


                                  ),

                                  Container(
                                      margin: EdgeInsets.all(10.0),
                                      child:
                                      RatingBar(
                                        itemSize: 14,
                                        wrapAlignment: WrapAlignment.end,
                                        initialRating: 3,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        unratedColor: Colors.white,
                                        glowColor: const Color(0xffe22525),
                                        ratingWidget: RatingWidget(
                                          full: Icon(Icons.star),
                                          half: Icon(Icons.star_half),
                                          empty: Icon(Icons.star_border_outlined),
                                        ),
                                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                        onRatingUpdate: (rating) {
                                          print(rating);

                                          feedback_rating = rating as String;
                                        },
                                      )
                                  )
                                ]
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                //  mainAxisSize: MainAxisSize.max,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children:<Widget>[
                                  Container(
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5.0,2.0,0,0),
                                      child: Text(
                                          'Please share your honest review',
                                          style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w300,fontFamily: 'Poppins'),textAlign: TextAlign.start
                                      ),
                                    ),
                                  ),
                                ]
                            ),


                            Container( margin: new EdgeInsets.all(15.0),
                              child:
                              TextFormField(
                                autofocus: false,
                                maxLines: 5,
                                style: TextStyle(color: Colors.black,fontFamily: 'Poppins'),
                                decoration: InputDecoration(fillColor: Colors.black12, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
                                )),
                                validator: (value) =>
                                value.isEmpty ? "Please enter description" : null,
                                onSaved: (value) => feedback_desc = value,
                                controller: feedbackdesccontroller,

                              ),
                            ),

                        GestureDetector(
                          onTap: () {

                            Fluttertoast.showToast(
                                msg: "Sending...",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                            senduserfeedback(context);
                            //   update_user_profile(context);
                            //print('do something');
                          },
                          child:
                            Container(
                              width: double.infinity,
                              height: 40,
                              margin: EdgeInsets.fromLTRB(
                                  10, 10, 10, 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all( width: 1,color: const Color(0xffe22525)),
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                image: const DecorationImage(
                                    image: AssetImage('assets/images/getnow.png'),
                                    fit: BoxFit.cover
                                ),
                              ), // button text
                              child: Text("Send Feedback", style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white

                              ),),
                            ),
                        ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 20),

                    Container(
                      margin: EdgeInsets.all(5.0),

                      decoration: BoxDecoration(
                        //  border: Border.all( width: 1,color: const Color(0xffe22525)Accent),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/getnow.png'),
                            fit: BoxFit.cover
                        ),
                      ), // b
                      child:
                      *//*  Card( shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),*//*
                      // color: const Color(0xffe22525)Accent,
                      //  elevation: 10,
                      // margin: EdgeInsets.all(15.0),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment : MainAxisAlignment.start,
                        crossAxisAlignment : CrossAxisAlignment.center,
                        children: <Widget>[

                          Container(margin: EdgeInsets.all(10.0),
                              child:

                              new RichText(
                                text: new TextSpan(
                                  text: 'Get Astro Gold At',
                                  style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w900,color: Colors.white,fontFamily: 'Poppins'),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: ' \Rs. 999 ',
                                      style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w900,fontFamily: 'Poppins',
                                        color: Colors.white,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    new TextSpan(
                                        text: ' \Rs. 299/-',
                                        style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w900,color: Colors.white,fontFamily: 'Poppins')
                                    ),
                                  ],
                                ),
                              )
                            *//*Text(
                          'Get Astro Gold At Rs. 999 Rs. 299/-',
                          style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w900,color: Colors.white,fontFamily: 'Poppins'),
                        ),
*//*
                          ),

                          Container(
                            //  margin: EdgeInsets.all(10.0),
                            child:
                            Text(
                                'Flat 10% off on every season',
                                style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'Poppins')
                            ),
                          ),

                          Container
                            (
                            child:   MaterialButton(
                              minWidth: 50,
                              height:30,
                              onPressed: (){
                                // Navigator.pushReplacementNamed(context, '/register');


                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              child: Text("Get Now",style: TextStyle(
                                  fontWeight: FontWeight.w600,fontSize: 12,
                                  color: Colors.black,fontFamily: 'Poppins'

                              ),),
                            ),
                          ),

                        ],
                      ),
                    ),
*/
                    //  ),


                  ],
                ),
                //  ),],),
             // ),
            ),
          ),
        ));
  }



/*
  Future<Map<String, dynamic>> _uploadImage(File image) async {


    //final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);
    print(imageUploadRequest);

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(
      'image', image.path,);

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['agent_id'] = session_agent_id;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {

        */
/* Fluttertoast.showToast(
            msg: "Mobile number already exists.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );*//*

        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      //  _resetS tate();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }
*/



  //Future <List<AstrologerDetails>> getnewstrolist() async {
  Future <List<AstrologerListingResponse>> getnewstrolist() async {
    final response =
    await http.post(AppUrl.astrologer_listing);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new AstrologerListingResponse.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }


  //Future <List<AstrologerListingResponse>> getastrogerlist() async {


  void getsession_userid() async{
    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
      agent_extension = logindata.getString('agent_ext');
      session_agent_mobile = logindata.getString('agent_mobile');
      session_agent_password = logindata.getString('agent_password');
    });
  }



/*
   shareonwhatsapp() async {
    var whatsapp ="+918097874046";
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
   // var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
*/
/*    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
    await launch(whatappURL_ios, forceSafariVC: false);
    }else{
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: new Text("whatsapp no installed")));
    }
    }else{*//*

    // android , web
    if( await canLaunch(whatsappURl_android)){
    await launch(whatsappURl_android);
    }else{
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: new Text("whatsapp no installed")));
    }
  //  }
  }
*/


  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(AppUrl.astrologer_listing);
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      setState(() {
        astrologerslist = items;
        searchlist = items;
        isLoading = false;
      });
    }else{
      astrologerslist = [];
      searchlist = [];
      isLoading = false;
    }
  }

  void senduserfeedback(BuildContext context) async {
    feedback_desc  = '';

    //  if (_userName.length !=10) {
    if (feedback_desc != null) {
      //  loaderFun(context, true);
      var _loginApiClient = LoginApiClient();
      // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
      UserFeedbackModel feedbackModel =  UserFeedbackModel();
      //_userName,_password,'1234','','',apkversion,'');
      feedbackModel.user_id = session_agent_id;
      feedbackModel.description = feedback_desc ;


      SendFeedbackResponse userModel =
      await _loginApiClient.send_user_feedback(feedbackModel);

      print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
      // (data?.isEmpty ?? true
      //  if (userModel?.status ?? true) {
      //   if (userModel!=null) {

     //` if (userModel.status == true) {
        print('Feedback sent successfully');

        //    feedbackdesccontroller.text('');

        Fluttertoast.showToast(
            msg: "Feedback sent successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: cf.Size.blockSizeHorizontal*3.5

        );

      feedbackdesccontroller.text = '';

     /* }
      else
      {
        print('Feedback sending failed');
        Fluttertoast.showToast(
            msg: "Feedback sending failed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }*/

    }
  }

  Future <List<TestimonalResponse>> gettestimonal() async {

    LoginApiClient api = LoginApiClient();

    testmonallist = await api.gettestimonals();

    //print("dataFromServer 1 :-${dataFromServer.length}");

    setState(() {
      testmonallist = testmonallist;
    });


  }

  void sendtodelete_queue(BuildContext context) async{

          //  loaderFun(context, true);
          var _loginApiClient = LoginApiClient();
          AgentDelRequestModel loginRequestModel = new AgentDelRequestModel();
          loginRequestModel.extension = agent_extension;

          UserChangePasswordResponseModel userModel = await _loginApiClient.delete_queue_member_record(loginRequestModel);
          print("!Q!Q!QQ!Q!Q!Q $userModel");
          if(userModel.status == true){
            print('status'+userModel.status.toString());
            print('Agent logout successful');

            Fluttertoast.showToast(
                msg: "Logged out successfully...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: cf.Size.blockSizeHorizontal*3.5
            );

           /* Navigator.popUntil(
              context,
              ModalRoute.withName('/'),
            );*/

          /*  Navigator.pushReplacement(context,new MaterialPageRoute(builder:
                (context) => Login()));
*/ /*Navigator.popUntil(
                context, (route) => route.isFirst);*/

            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                Login()), (Route<dynamic> route) => false);



          }
          else
          {
            //  loaderFun(context, false);
            Fluttertoast.showToast(
                msg: "Something went wrong...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: cf.Size.blockSizeHorizontal*3.5
            );

            print('Account does not exist');
          }


  }

  void update_status() async {

    //  loaderFun(context, true);
    var _loginApiClient = LoginApiClient();
    UpdateStatusRequest forgetPasswdRequestModel = new UpdateStatusRequest();
    forgetPasswdRequestModel.agent_id = session_agent_id;
    forgetPasswdRequestModel.type = status_type;

    if(status_type == 'Call')
      {
        forgetPasswdRequestModel.status = call_status;
      }
    else if(status_type == 'Chat') {
      forgetPasswdRequestModel.status = chat_status;
    }


    print('status '+forgetPasswdRequestModel.status.toString());
    UserChangePasswordResponseModel userModel = await _loginApiClient
        .update_status(forgetPasswdRequestModel);
    print("!Q!Q!QQ!Q!Q!Q $userModel");
    if (userModel.status == true) {
      print('Password sent to mobile number');

      Fluttertoast.showToast(
          msg: "Status updated successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize:cf.Size.blockSizeHorizontal*3.5
      );

    }
    else {
      //  loaderFun(context, false);
      print('Invalid mobile number');
    }


  }

  void getallstatus_call() async {

    setState(() {
      isLoading = true;
    });

    var _loginApiClient = LoginApiClient();
    StatusRequestModel model = StatusRequestModel();
    model.agent_id = session_agent_id;
    model.type = 'Call';
   // model.date = formatter;
    model.date = '';
    print(model.toString());

    StatusResponse userListingResponse = await _loginApiClient.get_status_call(model);

    print("!Q!Q!QQ!Q!Q!Q ${userListingResponse.toString()}");

    if (userListingResponse.status == true) {
      print(userListingResponse.data);
      setState(() {
        isLoading = false;
      });
      status_call = userListingResponse.data[0].status.toString();

      print('status_call ' +status_call.toString());
      setState(() {
        if(status_call=="Off")
        {
          isSwitched_call = false;
        }
        else if(status_call == "On")
        {
          isSwitched_call = true;
        }
      });




    }
    else {
      print(userListingResponse.message);
      isLoading = false;
    }


  }

  void getallstatus_chat() async{

    setState(() {
      isLoading = true;
    });

    var _loginApiClient = LoginApiClient();
    StatusRequestModel model = StatusRequestModel();
    model.agent_id = session_agent_id;
    model.type = 'Chat';
    //model.date = formatter;
    model.date = '';
    print(model.toString());

    StatusResponse userListingResponse = await _loginApiClient.get_status_call(model);

    print("!Q!Q!QQ!Q!Q!Q ${userListingResponse.toString()}");
    if (userListingResponse.status == true) {
      print(userListingResponse.data);
      setState(() {
        isLoading = false;
      });


      status_chat = userListingResponse.data[0].status.toString();

      print('status_chat ' +status_chat.toString());

      setState(() {
        if (status_chat == "Off") {
          isSwitched_chat = false;
        }
        else if (status_chat == "On") {
          isSwitched_chat = true;
        }
      });

    }
    else {
      print(userListingResponse.message);
      isLoading = false;
    }


  }


}


//on tap function
void call(String name){
  print(name);
}


Widget somethingWentWrongWithRetry(context, funCall){
  return Container(

      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.sentiment_dissatisfied,
            color: Colors.pink[400],
            // size: cf.Size.screenWidth/9,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Oops, Something went wrong.",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              //  fontSize: cf.Size.blockSizeHorizontal*4
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          Container(

              child: InkWell(
                splashColor: Colors.transparent,
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  // size: cf.Size.screenWidth/8,
                ),
                onTap: (){
                  funCall();
                },
              )
          )
        ],
      )
  );
}

