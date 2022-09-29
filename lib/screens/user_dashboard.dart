
import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_follow_request.dart';
import 'package:ascology_app/model/request/astro_request.dart';
import 'package:ascology_app/model/request/astro_request_model.dart';
import 'package:ascology_app/model/request/available_agent_request.dart';
import 'package:ascology_app/model/request/login_request.dart';
import 'package:ascology_app/model/request/user_feedback_request.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/AgentStatus_Response.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:ascology_app/model/response/astrologer_premium_response.dart';
import 'package:ascology_app/model/response/feedback_response.dart';
import 'package:ascology_app/model/response/login_response.dart';
import 'package:ascology_app/model/response/my_wallet_response.dart';
import 'package:ascology_app/model/response/service_details_response.dart';
import 'package:ascology_app/model/response/testimonal_response.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/screens/addmoney_towallet.dart';
import 'package:ascology_app/screens/astrologer_desc_page.dart';
import 'package:ascology_app/screens/astrologer_numerology.dart';
import 'package:ascology_app/screens/astrologer_psychology.dart';
import 'package:ascology_app/screens/astrologer_tarot.dart';
import 'package:ascology_app/screens/astrologers.dart';
import 'package:ascology_app/screens/basic_panchang.dart';
import 'package:ascology_app/screens/birth_details.dart';
import 'package:ascology_app/screens/chat_detail.dart';
import 'package:ascology_app/screens/client_testimonals.dart';
import 'package:ascology_app/screens/contact_us.dart';
import 'package:ascology_app/screens/current_avail_astrologers.dart';
import 'package:ascology_app/screens/daily_horoscope_page.dart';
import 'package:ascology_app/screens/horoscope.dart';
import 'package:ascology_app/screens/kundali_match.dart';
import 'package:ascology_app/screens/login.dart';
import 'package:ascology_app/screens/premium_astrologers.dart';
import 'package:ascology_app/screens/privacy_policy.dart';
import 'package:ascology_app/screens/user_call_history.dart';
import 'package:ascology_app/screens/user_chat.dart';
import 'package:ascology_app/screens/user_chat_history.dart';
import 'package:ascology_app/screens/user_chat_webview.dart';
import 'package:ascology_app/screens/user_gallery.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:ascology_app/screens/user_profile.dart';
import 'package:ascology_app/screens/user_services.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:ascology_app/utility/check_internet_connection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;

class UserDashboard extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  var wallet_balance;
  var required_rate;

  Future<bool> _onWillPop(BuildContext context) async {
    bool exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
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

  final formKey = GlobalKey<FormState>();

  bool is_agentavailable = false;

  // List astrologerslist = [];
  List<AstrologerDetails> astrologerslist_psycho = List();
  List<AstrologerDetails> astrologerslist_numero = List();
  List<AstrologerDetails> astrologerslist_tarot = List();
  List<AstrologerDetails> astrologerslist_astrology = List();
  List<AstrologerDetailsNew> astrologerslist_available = List();
  List searchlist = [];
  bool isLoading = false;

  var followbuttontext = 'Follow';
  var unfollowbuttontext = 'Following';
  // List<AstrologerDetails> dataFromServer = List();

  String user_email,feedback_rating,agent_status,got_agent_id,agent_mob,agent_ext,astro_agentname,astro_img,astro_mobile,astro_extension;

  String fcmtoken;
  String agent_id;


  TextEditingController emailcontroller = TextEditingController();
  TextEditingController feedbackdesccontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();
  String searchText="";

  //List<AstrologerDetails> astrologerlist = List();
  List<AstrologerListingResponse> astrologerlist = List();
  List<TestimonalResponse> testmonallist = List();
  List<AstrologerDetails> newastrolist = List();
  List<AstrologerDetails> allastrolgerlist = List();
  List<AstrologerDetailsNew> premiumlist = List();
  List<ServiceDetails> servicelist = List();
  AstrologerListingResponse _astrologerListingResponse;

  SharedPreferences logindata;
  String session_user_id,feedback_desc,search_value,session_user_mobile,session_user_password;
  Future <List<AstrologerListingResponse>> futureData;

  double double_rating = 0.0;
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();

    //call_user_low_balance();


    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {

          print("message.data11 ${message.data}");
          // LocalNotificationService.display(message);

        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {

          print("message.data22 ${message.data['_id']}");
        }
      },
    );

   // CheckConnection().createState();
    //  getnewstrolist();

   //


    getsession_userid();



    get_wallet_balance();


  //  checkuserexists(context);
   // print(session_user_id);
    fetchUser1();
    fetchUser2();
    fetchUser3();
    fetchUser4();
    getpremiumastrologers();
    get_agent_available();
    // futureData = getnewstrolist();

    //print(session_user_id);
    gettestimonal();
  //  getqueueagent();
    getservices();

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
      // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
      LoginRequestModel loginRequestModel = LoginRequestModel();
      //_userName,_password,'1234','','',apkversion,'');
      loginRequestModel.mobile = session_user_mobile;
      loginRequestModel.password = session_user_password;
      loginRequestModel.token = '';
      loginRequestModel.device_name = '';
      loginRequestModel.device_model = '';
      loginRequestModel.apk_version = '';
      loginRequestModel.imei_number = '';

      LoginResponseModel userModel =
      await _loginApiClient.loginUser(loginRequestModel);

      print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
      // (data?.isEmpty ?? true
      //  if (userModel?.status ?? true) {
      //   if (userModel!=null) {
      //  if (userModel.status == true) {
      if (userModel.status == true) {

      }
      else {

        Fluttertoast.showToast(
            msg: "Invalid login details...Please check your login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize:  cf.Size.blockSizeHorizontal * 3.5,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );


        print('User Login failed');
      }


  }

  void get_wallet_balance() async {

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    //  loaderFun(context, true);
    var _loginApiClient = LoginApiClient();
    // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
    UserRequestModel requestModel = UserRequestModel();
    //_userName,_password,'1234','','',apkversion,'');
    requestModel.user_id = session_user_id;

    WalletResponseModel details =
    await _loginApiClient.getwalletbalance(requestModel);

    print("!Q!Q!QQ!Q!Q!Q ${requestModel.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {

    try {
      if (details.status == true) {
          wallet_balance = details.data[0].amount.toString();
             }
      else {
        print('error');

        wallet_balance = '0';
        /*Fluttertoast.showToast(
            msg: "Invalid login details...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print('User Login failed');*/
      }
    }
    catch(Exception)
    {

    }

  }

  void sendfollow() async {
    /* setState(() {
      isLoading = true;
    });*/
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');
    session_user_mobile = logindata.getString('user_mobile');


    var _loginApiClient = LoginApiClient();
    // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
    AgentFollowRequestModel requestModel = AgentFollowRequestModel();
    //_userName,_password,'1234','','',apkversion,'');
    requestModel.agent_id = got_agent_id;
    requestModel.user_id = session_user_id;

    UserChangePasswordResponseModel userModel =
    await _loginApiClient.sendfollowagent(requestModel);

    if(userModel.status == true) {
      print('Following...');
      Fluttertoast.showToast(
          msg: "Sending update...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize:  cf.Size.blockSizeHorizontal * 3.5,
      );

      /*  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHomePage()),
      );*/
    }
    else {
      print('Failed');
    }

  }


  call_astrologer() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post('https://astroashram.com/call_api/callapi.php?extension='+session_user_mobile+'&code='+astro_extension+'&submit=call');
    // print(response.body);
    if(response.statusCode == 200){

      Fluttertoast.showToast(
          msg: "Calling...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize:  cf.Size.blockSizeHorizontal * 3.5,
      );


      Fluttertoast.showToast(
          msg: "You will receive a call from Astroashram in few minutes...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: cf.Size.blockSizeHorizontal * 3.5,
      );


      // var ite ms = json.decode(response.body)['data'];
      setState(() {
        //   astrologerslist = items;
        //  isLoading = false;
      });
    }else{
      //  astrologerslist = [];
      //  isLoading = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    //return SafeArea(
    cf.Size.init(context);

    return
     WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
              bottomSheet:

              Row(
                children: [
                  Flexible(child:
                  Container(
                    color: Color.fromARGB(243, 252, 253, 252),
                    child:
                    Row(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child:
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(175, 5),
                                  primary: const Color(0xffe22525),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),

                              onPressed: () {
                                Navigator.push(context, new MaterialPageRoute(builder:
                                    (context) => AvailableAstrologersPage()));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon( // <-- Icon
                                      Icons.call,
                                      size: 13.0,
                                      color: Colors.white
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Talk to Astrologer', textAlign: TextAlign
                                      .center, style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: cf.Size.blockSizeHorizontal * 2.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),), // <-- Text

                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child:
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(175, 5),
                                  primary: const Color(0xffe22525),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onPressed: () {
                               /* Navigator.push(context, new MaterialPageRoute(builder:
                                    (context) => UserChat()));*/

                                Navigator.push(context, new MaterialPageRoute(builder:
                                    (context) => AvailableAstrologersPage()));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon( // <-- Icon
                                      Icons.message,
                                      size: 12.0,
                                      color: Colors.white
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Chat with Astrologer', textAlign: TextAlign
                                      .center, style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: cf.Size.blockSizeHorizontal * 2.2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),), // <-- Text

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),

              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text('Dashboard', style: TextStyle(
                    color: Colors.white,
                    fontSize: cf.Size.blockSizeHorizontal * 4.5, fontFamily: 'Poppins'
                ),),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMoneyTowallet()),
                      );
                    },
                    icon: Image.asset('assets/images/wallet.png'),
                  ),


                  PopupMenuButton(
                    // add icon, by default "3 dot" icon
                    // icon: Icon(Icons.book)
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text("My Profile", style: TextStyle(
                                fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3
                              //  fontSize: 36.0,
                            ),),
                          ),

                          PopupMenuItem<int>(
                            value: 1,
                            child: Text("Call History", style: TextStyle(
                                fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3),
                            ),
                          ),

                          PopupMenuItem<int>(
                            value: 3,
                            child: Text("Chat History", style: TextStyle(
                                fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3),
                            ),
                          ),

                          PopupMenuItem<int>(
                            value: 2,
                            child: Text("Logout", style: TextStyle(
                                fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.3),
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 0) {
                          print("My account menu is selected.");

                          Navigator.push(context, new MaterialPageRoute(builder:
                              (context) => UserProfile()));
                        }
                        else if (value == 1) {
                          Navigator.push(context, new MaterialPageRoute(builder:
                              (context) => UserCallHistory()));
                        } else if (value == 2) {
                          print("Logout menu i s selected.");
                          logindata.setString('user_type', '');
                          logindata.setString('user_id', '');
                          logindata.setBool('userlogin', true);
                          /*Navigator.pushReplacement(
                              context, new MaterialPageRoute(builder:
                              (context) => Login()));*/
                          /*Navigator.popUntil(
                              context, (route) => route.isFirst);*/
                          /*Navigator.popUntil(
                            context,
                            ModalRoute.withName('/login'),
                          );*/
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              Login()), (Route<dynamic> route) => false);
                        }
                        else if (value == 3) {
                          Navigator.push(context, new MaterialPageRoute(builder:
                              (context) => UserChatHistory()));
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
                    /* DrawerHeader(
                    child: Text("AstroAshram")),*/
                    ListTile(
                      leading: SizedBox(
                          height: 30.0,
                          width: 30.0, // fixed width and height
                          child: Image.asset('assets/images/homesidemenu.png')
                      ),
                      /*  leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/homesidemenu.png'),radius: 15),*/
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {
                            Navigator.pop(context);
                            /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserHomePage()),
                      );*/

                           /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDashboard()),
                            );*/
                          },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.red),
                        ],
                      ),
                      title:  Text('Home',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),
                      ),
                      onTap: () {

                        Navigator.pop(context);
                        /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserHomePage()),
                    );*/
                       /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserDashboard()),
                        );*/
                      },
                    ),

                    /* const Divider(),
                ListTile(
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
                ),*/
                    const Divider(),
                    ListTile(

                      leading: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/astrologers.png'), radius: 15),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ServicesPage()),
                            );
                          },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.red),
                        ],
                      ),
                      title:  Text('Services',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServicesPage()),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      /*  leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/gallery.png'),radius: 15),*/
                      leading: SizedBox(
                          height: 30.0,
                          width: 30.0, // fixed width and height
                          child: Image.asset('assets/images/gallery.png')
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GalleryPage()),
                            );
                          },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.red),
                        ],
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
                          },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.red),
                        ],
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
                    /* ListTile(
                  leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/blogs.png'),radius: 15),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlogsPage()),
                      );}, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
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
                const Divider(),
*/

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
                          },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.red),
                        ],
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
                      IconButton(onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReferEarnPage()),
                      );}, icon: Icon(Icons.arrow_forward_ios_outlined),color: Colors.red),],
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
                          IconButton(onPressed: () async {
                            await Share.share(
                                'Check the below link for more information on astrology. https://astroashram.com/ ');
                          },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.red),
                        ],
                      ),
                      title:  Text('Share',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                      onTap: () async {
                        //shareonwhatsapp();

                        await Share.share(
                            'Check the below link for more information on astrology. https://astroashram.com/ ');


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
                            logindata.setString('user_type', '');
                            logindata.setString('user_id', '');
                            logindata.setBool('userlogin', true);
                           /* Navigator.popUntil(
                              context,
                              ModalRoute.withName('/login'),
                            );*/
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                Login()), (Route<dynamic> route) => false);
                           /* Navigator.popUntil(
                                context, (route) => route.isFirst);*/
                           /* Navigator.pushReplacement(
                                context, new MaterialPageRoute(builder:
                                (context) => Login()));*/
                          },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.red),
                        ],
                      ),
                      title:  Text('Logout',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*3.5),),
                      onTap: () {
                        //shareonwhatsapp();

                        logindata.setString('user_type', '');
                        logindata.setString('user_id', '');
                        logindata.setBool('userlogin', true);
                      /*  Navigator.popUntil(
                          context,
                          ModalRoute.withName('/login'),
                        );*/

                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            Login()), (Route<dynamic> route) => false);

                       /* Navigator.popUntil(
                            context, (route) => route.isFirst);*/
                       /* Navigator.pushReplacement(
                            context, new MaterialPageRoute(builder:
                            (context) => Login()));
*/
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

              body:

              SingleChildScrollView(
                /*  child:
            SizedBox(
              width:100.w,
              height: 100.h,*/
                child:


                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 90),
                  //  height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.
                  //width: MediaQuery.of(context).size.width,
                  child:
                  //  padding: EdgeInsets.all(20),
                  /*Flex( direction: Axis.vertical,
              children: [
              Expanded(*/
                  /* Flexible(
                child:*/
                  Column(

                    children: [
                      /*Text(
    _astrologerListingResponse.message,
    style: TextStyle(fontSize: 20),
    ),*/

                      /* TextFormField(

              autofocus: false,
              style: TextStyle(color: Colors.black,fontFamily: 'Poppins'),

              validator: (value) =>
              value.isEmpty ? "Search" : null,
              onSaved: (value) => search_value = value,
              controller: searchcontroller,
              decoration:
              buildInputDecoration('Search', Icons.search),
            ),*/


                      //  SizedBox(height: 20),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[

                              IconButton(
                                // minWidth: 25.0,
                                iconSize: 70,
                                icon: Image.asset(
                                    'assets/images/dailyhoroscope.png'),
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
                              Text('Daily Horoscope',
                                  textAlign: TextAlign.center, style: TextStyle(
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

                                icon: Image.asset(
                                    'assets/images/freekundali.png'),
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
                              Text('Free Kundali', textAlign: TextAlign.center,
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
                                icon: Image.asset(
                                    'assets/images/kundalimatch.png'),
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
                              Text('Panchang', textAlign: TextAlign.center,
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
                              fit: StackFit.passthrough,
                              //  fit: StackFit.expand,
                              children: <Widget>[

                                Image.asset(
                                  'assets/images/wishbackimg.png',
                                  fit: BoxFit.cover,
                                ),


                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      95, 20, 20, 0),
                                  child: Text(
                                    'Wishing someone special to be with you forever?',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: cf.Size.blockSizeHorizontal*3.2,
                                        color: Colors.white,
                                        fontFamily: 'Poppins'),),
                                ),


                              ]),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(

                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 140,
                        width: double.infinity,
                        child:
                        /* Expanded(
                        child:*/
                        GridView(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          //  crossAxisSpacing: 5,
                            mainAxisExtent: 140,
                         //   mainAxisSpacing: 5,
                          ),
                          children: [

                            GestureDetector(
                              onTap: () =>
                              {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Astrologers_PsychoPage();
                                      },
                                    ))
                              },
                              child:

                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: const Color(0xFF1ABC9C),
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    /*decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/psychology.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),*/
                                    child: Column(
                                      children: <Widget>[

                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),
                                          child: Center(
                                            child: new Image.asset(
                                              'assets/images/psychology.png',
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        new SizedBox(height: 10),
                                        new Container(
                                          child: new Text("Mental Wellness",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: cf.Size.blockSizeHorizontal*2.5,
                                                  fontFamily: 'Poppins'),
                                              textAlign: TextAlign.center),
                                        ),

                                      ],
                                    )
                                ),
                              ),

                            ),

                            GestureDetector(
                              onTap: () =>
                              {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AstrologersPage();
                                      },
                                    ))
                              },
                              child:
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: const Color(0xff3498DB),
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    /*decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/psychology.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),*/
                                    child: Column(
                                      children: <Widget>[

                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),
                                          child: Center(
                                            child: new Image.asset(
                                              'assets/images/astrology.png',
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        new SizedBox(height: 10),
                                        new Container(
                                          child: new Text("Astrology",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: cf.Size.blockSizeHorizontal*2.5,
                                                  fontFamily: 'Poppins'),
                                              textAlign: TextAlign.center),
                                        ),

                                      ],
                                    )
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
                                        return Astrologers_NumeroPage();
                                      },
                                    ))
                              },
                              child:

                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: const Color(0xFF9B59B6),
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    /*decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/psychology.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),*/
                                    child: Column(
                                      children: <Widget>[

                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),

                                          child: Center(
                                            child: new Image.asset(
                                              'assets/images/numerology.png',
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        new SizedBox(height: 10),
                                        new Container(
                                          child: new Text("Numerology",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: cf.Size.blockSizeHorizontal*2.2,
                                                  fontFamily: 'Poppins'),
                                              textAlign: TextAlign.center),
                                        ),

                                      ],
                                    )
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () =>
                              {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Astrologers_TarotPage();
                                      },
                                    ))
                              },
                              child:

                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: const Color(0xFFC0392B),
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    /*decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/psychology.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),*/
                                    child: Column(
                                      children: <Widget>[

                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),
                                          child: Center(
                                            child: new Image.asset(
                                              'assets/images/tarot.png',
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        new SizedBox(height: 10),
                                        new Container(
                                          child: new Text("Tarot Reading",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: cf.Size.blockSizeHorizontal*2.5,
                                                  fontFamily: 'Poppins'),
                                              textAlign: TextAlign.center),
                                        ),

                                      ],
                                    )
                                ),
                              ),),


                          ],
                        ),
                        // ),
                      ),
                      SizedBox(height: 20),

                      //Premium list

                      Card(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/bg_image_new.jpg"),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                              child: Column(
                                  children: <Widget>[

                                    new

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 10, 0, 0),
                                            child: Text('Premium astrologers',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: cf.Size.blockSizeHorizontal*4,
                                                    fontFamily: 'Poppins')),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 15, 0),
                                            child:
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: 'View All',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Poppins-bold',
                                                      fontSize: cf.Size.blockSizeHorizontal*4,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        print(double_rating
                                                            .toString());
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  PremiumAstrologersPage()),
                                                        );
                                                      }),
                                              ]),
                                            ),
                                            // Text('View All', textAlign: TextAlign.end, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15)),
                                          )
                                        ]
                                    ),


                                    SizedBox(height: 10),



                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      height: 250,
                                      width: double.infinity,
                                      child:
                                      Column(
                                        children: [
                                          Flexible(
                                            child: //
                                            premiumlist.isNotEmpty

                                                ?
                                          RefreshIndicator(
                                            onRefresh: () async {
                                              await Future.delayed(Duration(seconds: 2));
                                              getpremiumastrologers();
                                            },
                                            child:
                                          GridView.builder(

                                            // scrollDirection: ,
                                            //  physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 8,
                                                mainAxisSpacing: 8,
                                                mainAxisExtent: 250,
                                                //childAspectRatio: 2
                                              ),

                                              itemCount: premiumlist.length,
                                              itemBuilder: (context, index) {
                                                if (premiumlist != null &&
                                                    premiumlist.length != 0) {
                                                  // key: ValueKey(astrologerslist[index]['agentname']);
                                                  key:
                                                  ValueKey(
                                                      premiumlist[index].agentname);
                                                  // return getCard(astrologerslist[index]);
                                                  String agent_id = premiumlist[index]
                                                      .id;
                                                  String follow_param = premiumlist[index]
                                                      .follow;

                                                  var fullName = premiumlist[index]
                                                      .agentname;
                                                  var price = premiumlist[index]
                                                      .b_rate;
                                                  var profileUrl = premiumlist[index]
                                                      .image;
                                                  String avg_rating = premiumlist[index]
                                                      .avg_rating;
                                                  var astro_chat_status_premium =
                                                      premiumlist[index].ChatStatus;
                                                  var astro_call_status_premium =
                                                      premiumlist[index]
                                                          .PhoneCallStatus;
                                                  astro_mobile =
                                                      premiumlist[index].mob;
                                                  astro_extension =
                                                      premiumlist[index].extension;

                                                  if (premiumlist[index]
                                                      .token == null) {
                                                     fcmtoken = '';
                                                  }
                                                  else {
                                                     fcmtoken = premiumlist[index].token;
                                                  }

                                                  if (premiumlist[index]
                                                      .avg_rating == null) {
                                                    double_rating = 0.0;
                                                  }
                                                  else {
                                                    double_rating = double.parse(
                                                        premiumlist[index]
                                                            .avg_rating);
                                                  }


                                                  return


                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return AstroDescription(
                                                                    agent_id: agent_id,
                                                                    agent_follow: follow_param);
                                                              },


                                                            ));
                                                      },
                                                      child:
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius
                                                                .circular(10.0),
                                                            border: Border.all(
                                                              width: 1.0,
                                                              color: const Color(
                                                                  0xffe22525),
                                                            )
                                                        ),
                                                        child:
                                                        /* Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child:*/ Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            //mainAxisSize: MainAxisSize.max,
                                                            children: <Widget>[

                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 10, 5, 0),
                                                                width: 110,
                                                                height: 110,
                                                                decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    //                   <--- border color
                                                                    width: 1.0,
                                                                  ),
                                                                ),

                                                                child:
                                                                CachedNetworkImage
                                                                  (
                                                                  /* imageBuilder: (context, imageProvider) => Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            image: DecorationImage(
                                                                image: imageProvider, fit: BoxFit.cover),
                                                          ),
                                                        ),*/
                                                                  //   imageBuilder: (context, imageProvider) =>
                                                                  imageUrl: "https://astroashram.com/uploads/agent/" +
                                                                      profileUrl,
                                                                  placeholder: (
                                                                      context,
                                                                      url) => new CircularProgressIndicator(),
                                                                  errorWidget: (
                                                                      context, url,
                                                                      error) =>
                                                                  new Image.asset(
                                                                      'assets/images/profile.png'),
                                                                ),

                                                              ),

                                                              Text(fullName,
                                                                textAlign: TextAlign
                                                                    .center,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontFamily: 'Poppins',
                                                                    fontSize: cf.Size.blockSizeHorizontal*2.5,
                                                                    fontWeight: FontWeight
                                                                        .w600
                                                                ),),
                                                              //  ),


                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 1, 0, 2),
                                                                child:
                                                                Text(
                                                                  'Rs. ' + price +
                                                                      ' /min',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                    fontSize: cf.Size.blockSizeHorizontal*2,
                                                                  ),),
                                                              ),

                                                              SizedBox(height: 3),

                                                              //  Expanded(child:
                                                              SizedBox(
                                                                width: 60,
                                                                height: 6,
                                                                //   alignment: Alignment.center,
                                                                child: RatingBar
                                                                    .builder(
                                                                  itemSize: 10,
                                                                  wrapAlignment: WrapAlignment
                                                                      .center,
                                                                  initialRating: double_rating,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating: true,
                                                                  itemCount: 5,
                                                                  ignoreGestures: true,
                                                                  unratedColor: Colors
                                                                      .grey,
                                                                  glowColor: const Color(
                                                                      0xffFFFF00),
                                                                  itemBuilder: (
                                                                      context, _) =>
                                                                      Icon(
                                                                        Icons.star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                  /*  ratingWidget: RatingWidget(
                              full: Icon(Icons.star),
                              half: Icon(Icons.star_half),
                              empty: Icon(Icons.star_border_outlined),
                            ),*/
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 1.0),

                                                                  /* onRatingUpdate: (rating) {
                                                    //print(astro_rating);

                                                  },*/
                                                                ),
                                                              ),
                                                              //  ),


                                                              /*  ButtonBar(
                                  children: [*/

                                                              Expanded(child:

                                                              Column(children: <
                                                                  Widget>[
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                      10, 10, 10,
                                                                      10),
                                                                  child: Table(

                                                                    children: [

                                                                      TableRow(
                                                                          children: [

                                                                            Material(
                                                                              color: Colors
                                                                                  .transparent,
                                                                              child:
                                                                              Ink(
                                                                                height: 20,
                                                                                decoration: const ShapeDecoration(
                                                                                  color: const Color(
                                                                                      0xffF5F5F5),
                                                                                  shape: CircleBorder(),
                                                                                ),
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets
                                                                                      .all(
                                                                                      0.0),
                                                                                  onPressed: () {
                                                                                  //  get_wallet_balance();

                                                                                    if (astro_call_status_premium ==
                                                                                        "1") {
                                                                                      if (wallet_balance !=
                                                                                          '0') {

                                                                                        double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                        int final_rate = tocalculate.floor();


                                                                                        if (final_rate ==
                                                                                            2 ||
                                                                                            final_rate >
                                                                                                2) {
                                                                                          call_astrologer();
                                                                                        }
                                                                                      }
                                                                                      else {
                                                                                        Fluttertoast
                                                                                            .showToast(
                                                                                            msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                            toastLength: Toast
                                                                                                .LENGTH_SHORT,
                                                                                            gravity: ToastGravity
                                                                                                .CENTER,
                                                                                            timeInSecForIosWeb: 1,
                                                                                            backgroundColor: Colors
                                                                                                .black,
                                                                                            textColor: Colors
                                                                                                .white,
                                                                                          fontSize: cf.Size.blockSizeHorizontal*2.5,
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                    else
                                                                                    if (astro_call_status_premium ==
                                                                                        "0") {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is unavailable, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }

                                                                                    else {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is busy, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }

                                                                                    //  You enter here what you want the button to do once the user interacts with it
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons
                                                                                        .call,
                                                                                    color: (astro_call_status_premium ==
                                                                                        "1")
                                                                                        ? Colors
                                                                                        .green
                                                                                        : (astro_call_status_premium ==
                                                                                        "0")
                                                                                        ? Colors
                                                                                        .black
                                                                                        : Colors
                                                                                        .red,
                                                                                  ),
                                                                                  iconSize: 18.0,
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            Material(
                                                                              color: Colors
                                                                                  .transparent,
                                                                              child:

                                                                              Ink(
                                                                                height: 20.0,
                                                                                decoration: const ShapeDecoration(
                                                                                  color: const Color(
                                                                                      0xffF5F5F5),
                                                                                  shape: CircleBorder(

                                                                                  ),
                                                                                ),
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets
                                                                                      .all(
                                                                                      0.0),
                                                                                  onPressed: () {
                                                                                    print(
                                                                                        astro_chat_status_premium);
                                                                                  //  get_wallet_balance();

                                                                                    if (astro_chat_status_premium ==
                                                                                        "1") {
                                                                                      if (wallet_balance !=
                                                                                          '0') {
                                                                                        double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                        int final_rate = tocalculate.floor();


                                                                                        if (final_rate ==
                                                                                            2 ||
                                                                                            final_rate >
                                                                                                2) {
                                                                                         /* Navigator.push(context,
                                                                                              MaterialPageRoute(
                                                                                                builder: (context) {
                                                                                                  return UserChatWebview(chat_agent_id: agent_id) ;
                                                                                                },
                                                                                              ));*/
                                                                                          Navigator
                                                                                              .push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                builder: (
                                                                                                    context) {
                                                                                                  return ChatDetailPage(
                                                                                                      chat_agent_id: agent_id,
                                                                                                      chat_agent_name: fullName,
                                                                                                      chat_agent_img: profileUrl,
                                                                                                      chat_fcm_token:fcmtoken
                                                                                                    // chat_agent_price: astro_price
                                                                                                  );
                                                                                                },
                                                                                              ));
                                                                                        }
                                                                                      }
                                                                                      else {
                                                                                        Fluttertoast
                                                                                            .showToast(
                                                                                            msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                            toastLength: Toast
                                                                                                .LENGTH_SHORT,
                                                                                            gravity: ToastGravity
                                                                                                .CENTER,
                                                                                            timeInSecForIosWeb: 1,
                                                                                            backgroundColor: Colors
                                                                                                .black,
                                                                                            textColor: Colors
                                                                                                .white,
                                                                                          fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                    else
                                                                                    if (astro_chat_status_premium ==
                                                                                        "0") {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is unavailable, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }

                                                                                    else {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is busy, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }

                                                                                    //  You enter here what you want the button to do once the user interacts with it
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons
                                                                                        .message,
                                                                                    color: (astro_chat_status_premium ==
                                                                                        "1")
                                                                                        ? Colors
                                                                                        .green
                                                                                        : (astro_chat_status_premium ==
                                                                                        "0")
                                                                                        ? Colors
                                                                                        .black
                                                                                        : Colors
                                                                                        .red,
                                                                                  ),
                                                                                  iconSize: 18.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ]),
                                                              ),

                                                              /* Expanded(child:
                                                SizedBox(
                                                  // margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                                  height: 15,
                                                  //   width : 60 ,
                                                  child:

                                                  ElevatedButton(

                                                    child:

                                                    Text(followbuttontext, style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                                        fontSize: 10
                                                    ),),

                                                    onPressed: () {

                                                      sendfollow();

                                                      setState(() {

                                                        if(followbuttontext == 'Follow') {
                                                          followbuttontext = 'Unfollow';
                                                        }
                                                        else if(followbuttontext == 'Unfollow')
                                                        {
                                                          followbuttontext = 'Follow';
                                                        }

                                                      });


                                                    },

                                                    style: ElevatedButton.styleFrom(
                                                      onPrimary: Colors.red,
                                                      primary: const Color(0xffe22525),
                                                      onSurface: Colors.grey,

                                                    ),
                                                  ),
                                                ),
                                                ),*/


                                                            ]

                                                        ),
                                                      ),
                                                      //  ),


                                                    );
                                                }
                                                else {

                                                }
                                              }),
                                    )

                                                : Center(child: new CircularProgressIndicator()),

                              ),
                                        ],
                                      )
                      )

                                  ]))),
                      SizedBox(height: 10),

                      //Currently Available

                      Card(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          color: Color(0xffF8F9F9),
                          child: Column(
                            children: <Widget>[

                              new


                              Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                      child: Text('Currently Available',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                              fontFamily: 'Poppins')),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                                      child:
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: 'View All',
                                              style: TextStyle(
                                                  color: const Color(
                                                      0xffe22525),
                                                  fontFamily: 'Poppins',
                                                fontSize: cf.Size.blockSizeHorizontal*3.5,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AvailableAstrologersPage()),
                                                  );
                                                }),
                                        ]),
                                      ),
                                      // Text('View All', textAlign: TextAlign.end, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15)),
                                    )
                                  ]
                              ),


                              SizedBox(height: 5),


                              Container(

                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                height: 220,
                                width: double.infinity,
                                child:
                                Column(
                                  children: [
                                    Flexible(
                                      child: //
                                      astrologerslist_available.isNotEmpty

                                          ?
                                      RefreshIndicator(
                                        onRefresh: () async {
                                          await Future.delayed(Duration(seconds: 2));
                                          get_agent_available();
                                        },
                                        child:
                                        GridView.builder(

                                      // scrollDirection: ,
                                      //  physics: NeverScrollableScrollPhysics(),
                                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          /*crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,*/
                                          mainAxisExtent: 220,
                                          //childAspectRatio: 2
                                        ),

                                        itemCount: astrologerslist_available.length,
                                        itemBuilder: (context, index) {
                                          if (astrologerslist_available != null &&
                                              astrologerslist_available.length !=
                                                  0) {
                                            // key: ValueKey(astrologerslist[index]['agentname']);
                                            key:
                                            ValueKey(
                                                astrologerslist_available[index]
                                                    .agentname);
                                            // return getCard(astrologerslist[index]);
                                            String agent_id = astrologerslist_available[index]
                                                .id;
                                            String follow_param = astrologerslist_available[index]
                                                .follow;

                                            var fullName = astrologerslist_available[index]
                                                .agentname;
                                            var price = astrologerslist_available[index]
                                                .b_rate;
                                            var profileUrl = astrologerslist_available[index]
                                                .image;
                                            String avg_rating = astrologerslist_available[index]
                                                .avg_rating;
                                            var astro_chat_status_available =
                                                astrologerslist_available[index]
                                                    .ChatStatus;
                                            var astro_call_status_available =
                                                astrologerslist_available[index]
                                                    .PhoneCallStatus;
                                            astro_mobile =
                                                astrologerslist_available[index]
                                                    .mob;
                                            astro_extension =
                                                astrologerslist_available[index]
                                                    .extension;
                                            if (astrologerslist_available[index]
                                                .token == null) {
                                              fcmtoken = '';
                                            }
                                            else {
                                              fcmtoken = astrologerslist_available[index].token;
                                            }

                                            if (astrologerslist_available[index]
                                                .avg_rating == null) {
                                              double_rating = 0.0;
                                            }
                                            else {
                                              double_rating = double.parse(
                                                  astrologerslist_available[index]
                                                      .avg_rating);
                                            }


                                            return

                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return
                                                            AstroDescription(
                                                                agent_id: agent_id,
                                                                agent_follow: follow_param);
                                                        },
                                                      ));
                                                },
                                                child:
                                                Container(
                                                  /* decoration:BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: const Color(0xffe22525),
                                                )
                                            ),*/
                                                  child:
                                                  /* Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child:*/
                                                  /* ListTile(
                                              title: */
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      //mainAxisSize: MainAxisSize.max,
                                                      children: <Widget>[

                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(0, 0, 0, 0),
                                                          width: 110,
                                                          height: 110,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              //                   <--- border color
                                                              width: 1.0,
                                                            ),
                                                          ),

                                                          child:
                                                          CachedNetworkImage
                                                            (
                                                            /* imageBuilder: (context, imageProvider) => Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            image: DecorationImage(
                                                                image: imageProvider, fit: BoxFit.cover),
                                                          ),
                                                        ),*/
                                                            //   imageBuilder: (context, imageProvider) =>
                                                            imageUrl: "https://astroashram.com/uploads/agent/" +
                                                                profileUrl,
                                                            placeholder: (context,
                                                                url) => new CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                url, error) =>
                                                            new Image.asset(
                                                                'assets/images/profile.png'),
                                                          ),

                                                        ),


                                                        Text(fullName,
                                                          textAlign: TextAlign
                                                              .center,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: cf.Size.blockSizeHorizontal*2.5,
                                                              fontWeight: FontWeight
                                                                  .w600
                                                          ),),
                                                        //  ),


                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(0, 1, 0, 2),
                                                          child:
                                                          Text('Rs. ' + price +
                                                              ' /min',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily: 'Poppins',
                                                              fontSize: cf.Size.blockSizeHorizontal*2.3,
                                                            ),),
                                                        ),


                                                        SizedBox(height:3),
                                                        //  Expanded(child:
                                                        SizedBox(
                                                          width: 60,
                                                          height: 8,
                                                          //   alignment: Alignment.center,
                                                          child: RatingBar.builder(
                                                            itemSize: 10,
                                                            wrapAlignment: WrapAlignment
                                                                .center,
                                                            initialRating: double_rating,
                                                            direction: Axis
                                                                .horizontal,
                                                            allowHalfRating: true,
                                                            itemCount: 5,
                                                            ignoreGestures: true,
                                                            unratedColor: Colors
                                                                .grey,
                                                            glowColor: const Color(
                                                                0xffFFFF00),
                                                            itemBuilder: (context,
                                                                _) =>
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                            /*  ratingWidget: RatingWidget(
                                      full: Icon(Icons.star),
                                      half: Icon(Icons.star_half),
                                      empty: Icon(Icons.star_border_outlined),
                                    ),*/
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                horizontal: 1.0),

                                                            onRatingUpdate: (
                                                                rating) {
                                                              //print(astro_rating);

                                                            },
                                                          ),
                                                        ),
                                                        //  ),


                                                        /*  ButtonBar(
                                          children: [*/


                                                        // main code for call and chat
                                                        Column(children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                10, 5, 10, 10),
                                                            child: Table(

                                                              children: [

                                                                TableRow(children: [

                                                                  Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                    Ink(
                                                                      height: 20,
                                                                      decoration: const ShapeDecoration(
                                                                        color: const Color(
                                                                            0xffF5F5F5),
                                                                        shape: CircleBorder(),
                                                                      ),
                                                                      child: IconButton(
                                                                        padding: EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                        onPressed: () {


                                                                          if (astro_call_status_available ==
                                                                              "1") {
                                                                            if (wallet_balance !=
                                                                                '0') {
                                                                              double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                              int final_rate = tocalculate.floor();


                                                                              if (final_rate ==
                                                                                  2 ||
                                                                                  final_rate >
                                                                                      2) {
                                                                                call_astrologer();
                                                                              }
                                                                            }
                                                                            else {
                                                                              Fluttertoast
                                                                                  .showToast(
                                                                                  msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                  toastLength: Toast
                                                                                      .LENGTH_SHORT,
                                                                                  gravity: ToastGravity
                                                                                      .CENTER,
                                                                                  timeInSecForIosWeb: 1,
                                                                                  backgroundColor: Colors
                                                                                      .black,
                                                                                  textColor: Colors
                                                                                      .white,
                                                                                fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                              );
                                                                            }
                                                                          }
                                                                          else
                                                                          if (astro_call_status_available ==
                                                                              "0") {
                                                                            Fluttertoast
                                                                                .showToast(
                                                                                msg: "Agent is unavailable, please try after sometime",
                                                                                toastLength: Toast
                                                                                    .LENGTH_SHORT,
                                                                                gravity: ToastGravity
                                                                                    .CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors
                                                                                    .black,
                                                                                textColor: Colors
                                                                                    .white,
                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                            );
                                                                          }

                                                                          else {
                                                                            Fluttertoast
                                                                                .showToast(
                                                                                msg: "Agent is busy, please try after sometime",
                                                                                toastLength: Toast
                                                                                    .LENGTH_SHORT,
                                                                                gravity: ToastGravity
                                                                                    .CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors
                                                                                    .black,
                                                                                textColor: Colors
                                                                                    .white,
                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                            );
                                                                          }

                                                                          //  You enter here what you want the button to do once the user interacts with it
                                                                        },
                                                                        icon: Icon(
                                                                          Icons
                                                                              .call,
                                                                          color: (astro_call_status_available ==
                                                                              "1")
                                                                              ? Colors
                                                                              .green
                                                                              : (astro_call_status_available ==
                                                                              "0")
                                                                              ? Colors
                                                                              .black
                                                                              : Colors
                                                                              .red,
                                                                        ),
                                                                        iconSize: 18.0,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:

                                                                    Ink(
                                                                      height: 20.0,
                                                                      decoration: const ShapeDecoration(
                                                                        color: const Color(
                                                                            0xffF5F5F5),
                                                                        shape: CircleBorder(

                                                                        ),
                                                                      ),
                                                                      child: IconButton(
                                                                        padding: EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                        onPressed: () {
                                                                        //  get_wallet_balance();
                                                                          if (astro_chat_status_available ==
                                                                              "1") {
                                                                            if (wallet_balance !=
                                                                                '0') {
                                                                              /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;
*/
                                                                              double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                              int final_rate = tocalculate.floor();


                                                                              if (final_rate ==
                                                                                  2 ||
                                                                                  final_rate >
                                                                                      2) {

                                                                               /* Navigator.push(context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) {
                                                                                        return UserChatWebview(chat_agent_id: agent_id) ;
                                                                                      },
                                                                                    ));*/
                                                                                Navigator
                                                                                    .push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) {
                                                                                        return ChatDetailPage(
                                                                                            chat_agent_id: agent_id,
                                                                                            chat_agent_name: fullName,
                                                                                            chat_agent_img: profileUrl,
                                                                                            chat_fcm_token:fcmtoken
                                                                                          // chat_agent_price: astro_price
                                                                                        );
                                                                                      },
                                                                                    ));
                                                                              }
                                                                            }

                                                                            else {
                                                                              Fluttertoast
                                                                                  .showToast(
                                                                                  msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                  toastLength: Toast
                                                                                      .LENGTH_SHORT,
                                                                                  gravity: ToastGravity
                                                                                      .CENTER,
                                                                                  timeInSecForIosWeb: 1,
                                                                                  backgroundColor: Colors
                                                                                      .black,
                                                                                  textColor: Colors
                                                                                      .white,
                                                                                fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                              );
                                                                            }
                                                                          }
                                                                          else
                                                                          if (astro_chat_status_available ==
                                                                              "0") {
                                                                            Fluttertoast
                                                                                .showToast(
                                                                                msg: "Agent is unavailable, please try after sometime",
                                                                                toastLength: Toast
                                                                                    .LENGTH_SHORT,
                                                                                gravity: ToastGravity
                                                                                    .CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors
                                                                                    .black,
                                                                                textColor: Colors
                                                                                    .white,
                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                            );
                                                                          }

                                                                          else {
                                                                            Fluttertoast
                                                                                .showToast(
                                                                                msg: "Agent is busy, please try after sometime",
                                                                                toastLength: Toast
                                                                                    .LENGTH_SHORT,
                                                                                gravity: ToastGravity
                                                                                    .CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors
                                                                                    .black,
                                                                                textColor: Colors
                                                                                    .white,
                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                            );
                                                                          }
                                                                          //  You enter here what you want the button to do once the user interacts with it
                                                                        },
                                                                        icon: Icon(
                                                                          Icons
                                                                              .message,
                                                                          color: (astro_chat_status_available ==
                                                                              "1")
                                                                              ? Colors
                                                                              .green
                                                                              : (astro_chat_status_available ==
                                                                              "0")
                                                                              ? Colors
                                                                              .black
                                                                              : Colors
                                                                              .red,
                                                                        ),
                                                                        iconSize: 18.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),

                                                        /* Expanded(child:
                                                    SizedBox(
                                                      // margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                                      height: 15,
                                                      //   width : 60 ,
                                                      child:

                                                      ElevatedButton(

                                                        child:

                                                        Text(followbuttontext, style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                                            fontSize: 10
                                                        ),),

                                                        onPressed: () {

                                                          sendfollow();

                                                          setState(() {

                                                            if(followbuttontext == 'Follow') {
                                                              followbuttontext = 'Unfollow';
                                                            }
                                                            else if(followbuttontext == 'Unfollow')
                                                            {
                                                              followbuttontext = 'Follow';
                                                            }

                                                          });


                                                        },

                                                        style: ElevatedButton.styleFrom(
                                                          onPrimary: Colors.red,
                                                          primary: const Color(0xffe22525),
                                                          onSurface: Colors.grey,

                                                        ),
                                                      ),
                                                    ),
                                                    ),*/


                                                      ]

                                                  ),
                                                  // ),
                                                  //  ),


                                                ),
                                              );
                                          }
                                        }),
                              )
                                          : Center(child: new CircularProgressIndicator()),

                                    ),
                                  ],
                                ),
                              )


                            ],
                          ),
                        ),
                      ),

                      //  SizedBox(height: 10),
                      //Psychology

                      Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              color: Colors.white,
                              child: Column(
                                  children: <Widget>[

                                    new


                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 10, 0, 0),
                                            child: Text('Mental Wellness',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    fontFamily: 'Poppins')),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 15, 0),
                                            child:
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: 'View All',
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffe22525),
                                                        fontFamily: 'Poppins',
                                                      fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  Astrologers_PsychoPage()),
                                                        );
                                                      }),
                                              ]),
                                            ),
                                            // Text('View All', textAlign: TextAlign.end, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15)),
                                          )
                                        ]
                                    ),


                                    SizedBox(height: 5),


                                    Container(

                                      margin: EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      height: 220,
                                      width: double.infinity,
                                      child:
                                      Column(
                                        children: [
                                          Flexible(
                                              child: //
                                              astrologerslist_psycho.isNotEmpty

                                                  ?
                                              RefreshIndicator(
                                                onRefresh: () async {
                                                  await Future.delayed(Duration(seconds: 2));
                                                  fetchUser1();
                                                },
                                                child: GridView.builder(

                                            // scrollDirection: ,
                                            //  physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 8,
                                                mainAxisExtent: 220,
                                                //childAspectRatio: 2
                                              ),

                                              itemCount: astrologerslist_psycho.length,
                                              itemBuilder: (context, index) {
                                                if (astrologerslist_psycho !=
                                                    null &&
                                                    astrologerslist_psycho.length !=
                                                        0) {
                                                  // key: ValueKey(astrologerslist[index]['agentname']);
                                                  key:
                                                  ValueKey(
                                                      astrologerslist_psycho[index]
                                                          .agentname);
                                                  // return getCard(astrologerslist[index]);
                                                  String agent_id = astrologerslist_psycho[index]
                                                      .ID;
                                                  String follow_param = astrologerslist_psycho[index]
                                                      .follow;

                                                  print(agent_id);
                                                  var fullName = astrologerslist_psycho[index]
                                                      .agentname;
                                                  var price = astrologerslist_psycho[index]
                                                      .b_rate;
                                                  var profileUrl = astrologerslist_psycho[index]
                                                      .image;
                                                  String avg_rating = astrologerslist_psycho[index]
                                                      .avg_rating;
                                                  var astro_chat_status_psycho =
                                                      astrologerslist_psycho[index]
                                                          .ChatStatus;
                                                  var astro_call_status_psycho =
                                                      astrologerslist_psycho[index]
                                                          .PhoneCallStatus;
                                                  astro_mobile =
                                                      astrologerslist_psycho[index]
                                                          .mob;
                                                  astro_extension =
                                                      astrologerslist_psycho[index]
                                                          .extension;
                                                  if (astrologerslist_psycho[index]
                                                      .token == null) {
                                                    fcmtoken = '';
                                                  }
                                                  else {
                                                    fcmtoken = astrologerslist_psycho[index].token;
                                                  }

                                                  if (astrologerslist_psycho[index]
                                                      .avg_rating == null) {
                                                    double_rating = 0.0;
                                                  }
                                                  else {
                                                    double_rating = double.parse(
                                                        astrologerslist_psycho[index]
                                                            .avg_rating);
                                                  }


                                                  return

                                                    GestureDetector(
                                                      onTap: () {
                                                        print(agent_id);
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return AstroDescription(
                                                                    agent_id: agent_id,
                                                                    agent_follow: follow_param);
                                                              },
                                                            ));
                                                      },
                                                      child:
                                                      Container(
                                                        /* decoration:BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xffe22525),
                                          )
                                  ),*/
                                                        child:
                                                        /* Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child:*/ Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            //mainAxisSize: MainAxisSize.max,
                                                            children: <Widget>[

                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                                width: 110,
                                                                height: 110,
                                                                decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    //                   <--- border color
                                                                    width: 1.0,
                                                                  ),
                                                                ),

                                                                child:
                                                                CachedNetworkImage
                                                                  (
                                                                  /* imageBuilder: (context, imageProvider) => Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            image: DecorationImage(
                                                                image: imageProvider, fit: BoxFit.cover),
                                                          ),
                                                        ),*/
                                                                  //   imageBuilder: (context, imageProvider) =>
                                                                  imageUrl: "https://astroashram.com/uploads/agent/" +
                                                                      profileUrl,
                                                                  placeholder: (
                                                                      context,
                                                                      url) => new CircularProgressIndicator(),
                                                                  errorWidget: (
                                                                      context, url,
                                                                      error) =>
                                                                  new Image.asset(
                                                                      'assets/images/profile.png'),
                                                                ),

                                                              ),


                                                              Text(fullName,
                                                                textAlign: TextAlign
                                                                    .center,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontFamily: 'Poppins',
                                                                    fontSize: cf.Size.blockSizeHorizontal*2.3,
                                                                    fontWeight: FontWeight
                                                                        .w600
                                                                ),),
                                                              //  ),


                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 1, 0, 0),
                                                                child:
                                                                Text(
                                                                  'Rs. ' + price +
                                                                      ' /min',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                    fontSize: cf.Size.blockSizeHorizontal*2.0,
                                                                  ),),
                                                              ),

                                                              SizedBox(height:3),


                                                              //  Expanded(child:
                                                              SizedBox(
                                                                width: 60,
                                                                height: 6,
                                                                //   alignment: Alignment.center,
                                                                child: RatingBar
                                                                    .builder(
                                                                  itemSize: 10,
                                                                  wrapAlignment: WrapAlignment
                                                                      .center,
                                                                  initialRating: double_rating,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating: true,
                                                                  itemCount: 5,
                                                                  ignoreGestures: true,
                                                                  unratedColor: Colors
                                                                      .grey,
                                                                  glowColor: const Color(
                                                                      0xffFFFF00),
                                                                  itemBuilder: (
                                                                      context, _) =>
                                                                      Icon(
                                                                        Icons.star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                  /*  ratingWidget: RatingWidget(
                              full: Icon(Icons.star),
                              half: Icon(Icons.star_half),
                              empty: Icon(Icons.star_border_outlined),
                            ),*/
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 1.0),

                                                                  onRatingUpdate: (
                                                                      rating) {
                                                                    //print(astro_rating);

                                                                  },
                                                                ),
                                                              ),
                                                              //  ),


                                                              /*  ButtonBar(
                                  children: [*/


                                                              Column(children: <
                                                                  Widget>[
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                      10, 10, 10,
                                                                      10),
                                                                  child: Table(

                                                                    children: [

                                                                      TableRow(
                                                                          children: [

                                                                            Material(
                                                                              color: Colors
                                                                                  .transparent,
                                                                              child:
                                                                              Ink(
                                                                                height: 20,
                                                                                decoration: const ShapeDecoration(
                                                                                  color: const Color(
                                                                                      0xffF5F5F5),
                                                                                  shape: CircleBorder(),
                                                                                ),
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets
                                                                                      .all(
                                                                                      0.0),
                                                                                  onPressed: () {
                                                                                 //   get_wallet_balance();
                                                                                    print(
                                                                                        astro_call_status_psycho);
                                                                                    if (astro_call_status_psycho ==
                                                                                        "1") {
                                                                                      if (wallet_balance !=
                                                                                          '0') {
                                                                                        double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                        int final_rate = tocalculate.floor();


                                                                                        if (final_rate ==
                                                                                            2 ||
                                                                                            final_rate >
                                                                                                2) {
                                                                                          call_astrologer();
                                                                                        }
                                                                                      }
                                                                                      else {
                                                                                        Fluttertoast
                                                                                            .showToast(
                                                                                            msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                            toastLength: Toast
                                                                                                .LENGTH_SHORT,
                                                                                            gravity: ToastGravity
                                                                                                .CENTER,
                                                                                            timeInSecForIosWeb: 1,
                                                                                            backgroundColor: Colors
                                                                                                .black,
                                                                                            textColor: Colors
                                                                                                .white,
                                                                                          fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                    else
                                                                                    if (astro_call_status_psycho ==
                                                                                        "0") {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is unavailable, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }

                                                                                    else {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is busy, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }
                                                                                    //  You enter here what you want the button to do once the user interacts with it
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons
                                                                                        .call,
                                                                                    color: (astro_call_status_psycho ==
                                                                                        "1")
                                                                                        ? Colors
                                                                                        .green
                                                                                        : (astro_call_status_psycho ==
                                                                                        "0")
                                                                                        ? Colors
                                                                                        .black
                                                                                        : Colors
                                                                                        .red,
                                                                                  ),
                                                                                  iconSize: 18.0,
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            Material(
                                                                              color: Colors
                                                                                  .transparent,
                                                                              child:

                                                                              Ink(
                                                                                height: 20.0,
                                                                                decoration: const ShapeDecoration(
                                                                                  color: const Color(
                                                                                      0xffF5F5F5),
                                                                                  shape: CircleBorder(

                                                                                  ),
                                                                                ),
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets
                                                                                      .all(
                                                                                      0.0),
                                                                                  onPressed: () {
                                                                                  //  get_wallet_balance();
                                                                                    if (astro_chat_status_psycho ==
                                                                                        "1") {
                                                                                      if (wallet_balance !=
                                                                                          '0') {
                                                                                        /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;
*/ double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                        int final_rate = tocalculate.floor();


                                                                                        if (final_rate ==
                                                                                            2 ||
                                                                                            final_rate >
                                                                                                2) {

                                                                                         /* Navigator.push(context,
                                                                                              MaterialPageRoute(
                                                                                                builder: (context) {
                                                                                                  return UserChatWebview(chat_agent_id: agent_id) ;
                                                                                                },
                                                                                              ));*/
                                                                                          Navigator
                                                                                              .push(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                builder: (
                                                                                                    context) {
                                                                                                  return ChatDetailPage(
                                                                                                      chat_agent_id: agent_id,
                                                                                                      chat_agent_name: fullName,
                                                                                                      chat_agent_img: profileUrl,
                                                                                                      chat_fcm_token:fcmtoken
                                                                                                    // chat_agent_price: astro_price
                                                                                                  );
                                                                                                },
                                                                                              ));
                                                                                        }
                                                                                      }

                                                                                      else {
                                                                                        Fluttertoast
                                                                                            .showToast(
                                                                                            msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                            toastLength: Toast
                                                                                                .LENGTH_SHORT,
                                                                                            gravity: ToastGravity
                                                                                                .CENTER,
                                                                                            timeInSecForIosWeb: 1,
                                                                                            backgroundColor: Colors
                                                                                                .black,
                                                                                            textColor: Colors
                                                                                                .white,
                                                                                          fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                    else
                                                                                    if (astro_chat_status_psycho ==
                                                                                        "0") {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is unavailable, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }

                                                                                    else {
                                                                                      Fluttertoast
                                                                                          .showToast(
                                                                                          msg: "Agent is busy, please try after sometime",
                                                                                          toastLength: Toast
                                                                                              .LENGTH_SHORT,
                                                                                          gravity: ToastGravity
                                                                                              .CENTER,
                                                                                          timeInSecForIosWeb: 1,
                                                                                          backgroundColor: Colors
                                                                                              .black,
                                                                                          textColor: Colors
                                                                                              .white,
                                                                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                      );
                                                                                    }
                                                                                    //  You enter here what you want the button to do once the user interacts with it
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons
                                                                                        .message,
                                                                                    color: (astro_chat_status_psycho ==
                                                                                        "1")
                                                                                        ? Colors
                                                                                        .green
                                                                                        : (astro_chat_status_psycho ==
                                                                                        "0")
                                                                                        ? Colors
                                                                                        .black
                                                                                        : Colors
                                                                                        .red,
                                                                                  ),
                                                                                  iconSize: 18.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ]),

                                                              /* Expanded(child:
                                                SizedBox(
                                                  // margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                                  height: 15,
                                                  //   width : 60 ,
                                                  child:

                                                  ElevatedButton(

                                                    child:

                                                    Text(followbuttontext, style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                                        fontSize: 10
                                                    ),),

                                                    onPressed: () {

                                                      sendfollow();

                                                      setState(() {

                                                        if(followbuttontext == 'Follow') {
                                                          followbuttontext = 'Unfollow';
                                                        }
                                                        else if(followbuttontext == 'Unfollow')
                                                        {
                                                          followbuttontext = 'Follow';
                                                        }

                                                      });


                                                    },

                                                    style: ElevatedButton.styleFrom(
                                                      onPrimary: Colors.red,
                                                      primary: const Color(0xffe22525),
                                                      onSurface: Colors.grey,

                                                    ),
                                                  ),
                                                ),
                                                ),*/


                                                            ]

                                                        ),
                                                      ),
                                                      //  ),


                                                    );
                                                }
                                              }),
                                    )
                                                  : Center(child: new CircularProgressIndicator()),

                                          ),
                                        ],
                                      )
                                    )

                                  ]))),
                      // SizedBox(height: 10),


                      //Astrology

                      Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              color: Color(0xffF8F9F9),
                              child: Column(
                                  children: <Widget>[

                                    new


                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        // mainAxisSize: MainAxisSize.max,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 10, 0, 0),
                                            child: Text('Astrology',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    fontFamily: 'Poppins')),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 15, 0),
                                            child:
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: 'View All',
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffe22525),
                                                        fontFamily: 'Poppins',
                                                      fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  AstrologersPage()),
                                                        );
                                                      }),
                                              ]),
                                            ),
                                            // Text('View All', textAlign: TextAlign.end, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15)),
                                          )
                                        ]
                                    ),

                                    SizedBox(height: 5),

                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10, 0, 10, 20),
                                      height: 220,
                                      width: double.infinity,
                                      child:
                                      Column(
                                        children: [
                                          Flexible(
                                              child: //
                                              astrologerslist_astrology.isNotEmpty

                                                  ?
                                              RefreshIndicator(
                                                onRefresh: () async {
                                                  await Future.delayed(Duration(seconds: 2));
                                                  fetchUser4();
                                                },
                                                child:GridView.builder(
                                            // scrollDirection: ,
                                            //  physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 8,
                                                mainAxisExtent: 220,
                                                //childAspectRatio: 2
                                              ),
                                              itemCount: astrologerslist_astrology.length,
                                              itemBuilder: (context, index) {
                                                if (astrologerslist_astrology !=
                                                    null &&
                                                    astrologerslist_astrology
                                                        .length != 0) {
                                                  key:
                                                  ValueKey(
                                                      astrologerslist_astrology[index]
                                                          .agentname);
                                                  // return getCard(astrologerslist[index]);
                                                  String agent_id = astrologerslist_astrology[index]
                                                      .ID;
                                                  String follow_param = astrologerslist_astrology[index]
                                                      .follow;

                                                  var fullName = astrologerslist_astrology[index]
                                                      .agentname;
                                                  var price = astrologerslist_astrology[index]
                                                      .b_rate;
                                                  var profileUrl = astrologerslist_astrology[index]
                                                      .image;
                                                  String avg_rating = astrologerslist_astrology[index]
                                                      .avg_rating;

                                                  var astro_chat_status_astro =
                                                      astrologerslist_astrology[index]
                                                          .ChatStatus;
                                                  var astro_call_status_astro =
                                                      astrologerslist_astrology[index]
                                                          .PhoneCallStatus;
                                                  astro_mobile =
                                                      astrologerslist_astrology[index]
                                                          .mob;
                                                  astro_extension =
                                                      astrologerslist_astrology[index]
                                                          .extension;
                                                  if (astrologerslist_astrology[index]
                                                      .token == null) {
                                                    fcmtoken = '';
                                                  }
                                                  else {
                                                    fcmtoken = astrologerslist_astrology[index].token;
                                                  }

                                                  if (avg_rating == null) {
                                                    double_rating = 0.0;
                                                  }
                                                  else {
                                                    double_rating =
                                                        double.parse(avg_rating);
                                                  }
                                                  return


                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return AstroDescription(
                                                                    agent_id: agent_id,
                                                                    agent_follow: follow_param);
                                                              },
                                                            ));
                                                      },
                                                      child:
                                                      Container(
                                                        /* decoration:BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xffe22525),
                                            )
                                    ),*/
                                                        child:

                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            //mainAxisSize: MainAxisSize.max,
                                                            children: <Widget>[

                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                                width: 110,
                                                                height: 110,
                                                                decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    //                   <--- border color
                                                                    width: 1.0,
                                                                  ),
                                                                ),

                                                                child:
                                                                CachedNetworkImage
                                                                  (
                                                                  /* imageBuilder: (context, imageProvider) => Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            image: DecorationImage(
                                                                image: imageProvider, fit: BoxFit.cover),
                                                          ),
                                                        ),*/
                                                                  //   imageBuilder: (context, imageProvider) =>
                                                                  imageUrl: "https://astroashram.com/uploads/agent/" +
                                                                      profileUrl,
                                                                  placeholder: (
                                                                      context,
                                                                      url) => new CircularProgressIndicator(),
                                                                  errorWidget: (
                                                                      context, url,
                                                                      error) =>
                                                                  new Image.asset(
                                                                      'assets/images/profile.png'),
                                                                ),

                                                              ),

                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                                child: Text(
                                                                  fullName,
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: cf.Size.blockSizeHorizontal*2.3,
                                                                      fontWeight: FontWeight
                                                                          .w600
                                                                  ),),
                                                              ),


                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 1, 0, 0),
                                                                child: Text(
                                                                  'Rs. ' + price +
                                                                      ' /min',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: cf.Size.blockSizeHorizontal*2,
                                                                  ),),
                                                              ),

                                                              SizedBox(height: 3),

                                                              //   Expanded(child:
                                                              Container(
                                                                width: 60,
                                                                height: 8,
                                                                alignment: Alignment
                                                                    .center,
                                                                child: RatingBar
                                                                    .builder(
                                                                  itemSize: 10,
                                                                  wrapAlignment: WrapAlignment
                                                                      .center,
                                                                  initialRating: double_rating,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating: true,
                                                                  itemCount: 5,
                                                                  ignoreGestures: true,
                                                                  unratedColor: Colors
                                                                      .grey,
                                                                  glowColor: const Color(
                                                                      0xffFFFF00),
                                                                  itemBuilder: (
                                                                      context, _) =>
                                                                      Icon(
                                                                        Icons.star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                  /*  ratingWidget: RatingWidget(
                              full: Icon(Icons.star),
                              half: Icon(Icons.star_half),
                              empty: Icon(Icons.star_border_outlined),
                            ),*/
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 1.0),

                                                                  onRatingUpdate: (
                                                                      rating) {
                                                                    //print(astro_rating);

                                                                  },
                                                                ),
                                                              ),
                                                              //   ),


                                                              Center(
                                                                  child:
                                                                  Column(children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                          10, 10,
                                                                          10, 10),
                                                                      child: Table(

                                                                        children: [

                                                                          TableRow(
                                                                              children: [

                                                                                Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child:
                                                                                  Ink(
                                                                                    height: 20,
                                                                                    decoration: const ShapeDecoration(
                                                                                      color: const Color(
                                                                                          0xffF5F5F5),
                                                                                      shape: CircleBorder(),
                                                                                    ),
                                                                                    child: IconButton(
                                                                                      padding: EdgeInsets
                                                                                          .all(
                                                                                          0.0),
                                                                                      onPressed: () {
                                                                                      //  get_wallet_balance();

                                                                                        print(astro_call_status_astro);
                                                                                        if (astro_call_status_astro ==
                                                                                            "1") {
                                                                                          if (wallet_balance !=
                                                                                              '0') {
                                                                                            /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;
*/
                                                                                            double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                            int final_rate = tocalculate.floor();


                                                                                            if (final_rate ==
                                                                                                2 ||
                                                                                                final_rate >
                                                                                                    2) {
                                                                                              call_astrologer();
                                                                                            }
                                                                                          }
                                                                                          else {
                                                                                            Fluttertoast
                                                                                                .showToast(
                                                                                                msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                                toastLength: Toast
                                                                                                    .LENGTH_SHORT,
                                                                                                gravity: ToastGravity
                                                                                                    .CENTER,
                                                                                                timeInSecForIosWeb: 1,
                                                                                                backgroundColor: Colors
                                                                                                    .black,
                                                                                                textColor: Colors
                                                                                                    .white,
                                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                        else if (astro_call_status_astro ==
                                                                                            "0") {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is unavailable, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        else {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is busy, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        //  You enter here what you want the button to do once the user interacts with it
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons
                                                                                            .call,
                                                                                        color: (astro_call_status_astro ==
                                                                                            "1")
                                                                                            ? Colors
                                                                                            .green
                                                                                            : (astro_call_status_astro ==
                                                                                            "0")
                                                                                            ? Colors
                                                                                            .black
                                                                                            : Colors
                                                                                            .red,
                                                                                      ),
                                                                                      iconSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child:

                                                                                  Ink(
                                                                                    height: 20.0,
                                                                                    decoration: const ShapeDecoration(
                                                                                      color: const Color(
                                                                                          0xffF5F5F5),
                                                                                      shape: CircleBorder(

                                                                                      ),
                                                                                    ),
                                                                                    child: IconButton(
                                                                                      padding: EdgeInsets
                                                                                          .all(
                                                                                          0.0),
                                                                                      onPressed: () {
                                                                                     //   get_wallet_balance();
                                                                                        if (astro_chat_status_astro ==
                                                                                            "1") {
                                                                                          if (wallet_balance !=
                                                                                              '0') {
                                                                                            /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;
*/
                                                                                            double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                            int final_rate = tocalculate.floor();


                                                                                            if (final_rate ==
                                                                                                2 ||
                                                                                                final_rate >
                                                                                                    2) {
                                                                                              Navigator
                                                                                                  .push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (
                                                                                                        context) {
                                                                                                      return ChatDetailPage(
                                                                                                          chat_agent_id: agent_id,
                                                                                                          chat_agent_name: fullName,
                                                                                                          chat_agent_img: profileUrl,
                                                                                                          chat_fcm_token:fcmtoken
                                                                                                        // chat_agent_price: astro_price
                                                                                                      );
                                                                                                    },
                                                                                                  ));
                                                                                              /*Navigator.push(context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (context) {
                                                                                                      return UserChatWebview(chat_agent_id: agent_id) ;
                                                                                                    },
                                                                                                  ));*/
                                                                                            }
                                                                                          }

                                                                                          else {
                                                                                            Fluttertoast
                                                                                                .showToast(
                                                                                                msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                                toastLength: Toast
                                                                                                    .LENGTH_SHORT,
                                                                                                gravity: ToastGravity
                                                                                                    .CENTER,
                                                                                                timeInSecForIosWeb: 1,
                                                                                                backgroundColor: Colors
                                                                                                    .black,
                                                                                                textColor: Colors
                                                                                                    .white,
                                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                        else
                                                                                        if (astro_chat_status_astro ==
                                                                                            "0") {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is unavailable, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        else {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is busy, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        //  You enter here what you want the button to do once the user interacts with it
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons
                                                                                            .message,
                                                                                        color: (astro_chat_status_astro ==
                                                                                            "1")
                                                                                            ? Colors
                                                                                            .green
                                                                                            : (astro_chat_status_astro ==
                                                                                            "0")
                                                                                            ? Colors
                                                                                            .black
                                                                                            : Colors
                                                                                            .red,
                                                                                      ),
                                                                                      iconSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ])
                                                              ),


                                                              /* Expanded(child:
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                                    height: 12,
                                                    width : 60 ,
                                                    child:

                                                    ElevatedButton(

                                                      child:

                                                      Text(followbuttontext, style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                                          fontSize: 8
                                                      ),),

                                                      onPressed: () {

                                                        sendfollow();

                                                        setState(() {

                                                          if(followbuttontext == 'Follow') {
                                                            followbuttontext = 'Unfollow';
                                                          }
                                                          else if(followbuttontext == 'Unfollow')
                                                          {
                                                            followbuttontext = 'Follow';
                                                          }

                                                        });


                                                      },

                                                      style: ElevatedButton.styleFrom(
                                                        onPrimary: Colors.red,
                                                        primary: const Color(0xffe22525),
                                                        onSurface: Colors.grey,

                                                      ),
                                                    ),
                                                  ),
                                                      ),*/
                                                            ]
                                                        ),


                                                      ),
                                                    );
                                                }
                                              }),
                                    )
                                                  : Center(child: new CircularProgressIndicator()),

                          ),
                                        ],
                                      )
                      )
                                  ]))),


                      // SizedBox(height: 10),

                      //Numerology

                      Card(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              color: Colors.white,
                              child: Column(
                                  children: <Widget>[

                                    new

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 10, 0, 0),
                                            child: Text('Numerology',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    fontFamily: 'Poppins')),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 15, 0),
                                            child:
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: 'View All',
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffe22525),
                                                        fontFamily: 'Poppins',
                                                      fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  Astrologers_NumeroPage()),
                                                        );
                                                      }),
                                              ]),
                                            ),
                                            // Text('View All', textAlign: TextAlign.end, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15)),
                                          )
                                        ]
                                    ),

                                    SizedBox(height: 5),

                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10, 0, 10, 20),
                                      height: 220,
                                      width: double.infinity,
                                      child:
                                      Column(
                                        children: [
                                          Flexible(
                                              child: //
                                              astrologerslist_numero.isNotEmpty

                                                  ?
                                              RefreshIndicator(
                                                onRefresh: () async {
                                                  await Future.delayed(Duration(seconds: 2));
                                                  fetchUser2();
                                                },
                                                child:
                                                GridView.builder(
                                            // scrollDirection: ,
                                            //  physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 8,
                                                mainAxisExtent: 220,
                                                //childAspectRatio: 2
                                              ),
                                              itemCount: astrologerslist_numero.length,
                                              itemBuilder: (context, index) {
                                                if (astrologerslist_numero !=
                                                    null &&
                                                    astrologerslist_numero.length !=
                                                        0) {
                                                  key:
                                                  ValueKey(
                                                      astrologerslist_numero[index]
                                                          .agentname);
                                                  // return getCard(astrologerslist[index]);
                                                  String agent_id = astrologerslist_numero[index]
                                                      .ID;
                                                  String follow_param = astrologerslist_numero[index]
                                                      .follow;

                                                  var fullName = astrologerslist_numero[index]
                                                      .agentname;
                                                  var price = astrologerslist_numero[index]
                                                      .b_rate;
                                                  var profileUrl = astrologerslist_numero[index]
                                                      .image;
                                                  String avg_rating = astrologerslist_numero[index]
                                                      .avg_rating;

                                                  var astro_chat_status_numero =
                                                      astrologerslist_numero[index]
                                                          .ChatStatus;
                                                  var astro_call_status_numero =
                                                      astrologerslist_numero[index]
                                                          .PhoneCallStatus;
                                                  astro_mobile =
                                                      astrologerslist_numero[index]
                                                          .mob;
                                                  astro_extension =
                                                      astrologerslist_numero[index]
                                                          .extension;

                                                  if (astrologerslist_numero[index]
                                                      .token == null) {
                                                    fcmtoken = '';
                                                  }
                                                  else {
                                                    fcmtoken = astrologerslist_numero[index].token;
                                                  }

                                                  if (avg_rating == null) {
                                                    double_rating = 0.0;
                                                  }
                                                  else {
                                                    double_rating =
                                                        double.parse(avg_rating);
                                                  }
                                                  return
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return AstroDescription(
                                                                    agent_id: agent_id,
                                                                    agent_follow: follow_param);
                                                              },
                                                            ));
                                                      },
                                                      child:
                                                      Container(
                                                        /*decoration:BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xffe22525),
                                            )
                                    ),*/
                                                        child:

                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            //mainAxisSize: MainAxisSize.max,
                                                            children: <Widget>[

                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                                width: 110,
                                                                height: 110,
                                                                decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    //                   <--- border color
                                                                    width: 1.0,
                                                                  ),
                                                                ),

                                                                child:
                                                                CachedNetworkImage
                                                                  (
                                                                  /* imageBuilder: (context, imageProvider) => Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            image: DecorationImage(
                                                                image: imageProvider, fit: BoxFit.cover),
                                                          ),
                                                        ),*/
                                                                  //   imageBuilder: (context, imageProvider) =>
                                                                  imageUrl: "https://astroashram.com/uploads/agent/" +
                                                                      profileUrl,
                                                                  placeholder: (
                                                                      context,
                                                                      url) => new CircularProgressIndicator(),
                                                                  errorWidget: (
                                                                      context, url,
                                                                      error) =>
                                                                  new Image.asset(
                                                                      'assets/images/profile.png'),
                                                                ),

                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                                child: Text(
                                                                  fullName,
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: cf.Size.blockSizeHorizontal*2.3,
                                                                      fontWeight: FontWeight
                                                                          .w600
                                                                  ),),
                                                              ),


                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 1, 0, 0),
                                                                child: Text(
                                                                  'Rs. ' + price +
                                                                      ' /min',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                    fontSize: cf.Size.blockSizeHorizontal*2,
                                                                  ),),
                                                              ),

                                                              SizedBox(height: 3),

                                                              // Expanded(child:
                                                              Container(
                                                                width: 60,
                                                                height: 8,
                                                                alignment: Alignment
                                                                    .center,
                                                                child: RatingBar
                                                                    .builder(
                                                                  itemSize: 10,
                                                                  wrapAlignment: WrapAlignment
                                                                      .center,
                                                                  initialRating: double_rating,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating: true,
                                                                  itemCount: 5,
                                                                  ignoreGestures: true,
                                                                  unratedColor: Colors
                                                                      .grey,
                                                                  glowColor: const Color(
                                                                      0xffFFFF00),
                                                                  itemBuilder: (
                                                                      context, _) =>
                                                                      Icon(
                                                                        Icons.star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                  /*  ratingWidget: RatingWidget(
                              full: Icon(Icons.star),
                              half: Icon(Icons.star_half),
                              empty: Icon(Icons.star_border_outlined),
                            ),*/
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 1.0),

                                                                  onRatingUpdate: (
                                                                      rating) {
                                                                    //print(astro_rating);

                                                                  },
                                                                ),
                                                              ),
                                                              // ),


                                                              Center(
                                                                  child:
                                                                  Column(children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                          10, 10,
                                                                          10, 10),
                                                                      child: Table(

                                                                        children: [

                                                                          TableRow(
                                                                              children: [

                                                                                Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child:
                                                                                  Ink(
                                                                                    height: 20,
                                                                                    decoration: const ShapeDecoration(
                                                                                      color: const Color(
                                                                                          0xffF5F5F5),
                                                                                      shape: CircleBorder(),
                                                                                    ),
                                                                                    child: IconButton(
                                                                                      padding: EdgeInsets
                                                                                          .all(
                                                                                          0.0),
                                                                                      onPressed: () {
                                                                                      //  get_wallet_balance();

                                                                                        if (astro_call_status_numero ==
                                                                                            "1") {
                                                                                          if (wallet_balance !=
                                                                                              '0') {
                                                                                            /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_pri ce;
*/
                                                                                            double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                            int final_rate = tocalculate.floor();


                                                                                            if (final_rate ==
                                                                                                2 ||
                                                                                                final_rate >
                                                                                                    2) {
                                                                                              call_astrologer();
                                                                                            }
                                                                                          }
                                                                                          else {
                                                                                            Fluttertoast
                                                                                                .showToast(
                                                                                                msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                                toastLength: Toast
                                                                                                    .LENGTH_SHORT,
                                                                                                gravity: ToastGravity
                                                                                                    .CENTER,
                                                                                                timeInSecForIosWeb: 1,
                                                                                                backgroundColor: Colors
                                                                                                    .black,
                                                                                                textColor: Colors
                                                                                                    .white,
                                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                        else
                                                                                        if (astro_call_status_numero ==
                                                                                            "0") {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is unavailable, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        else {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is busy, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        //  You enter here what you want the button to do once the user interacts with it
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons
                                                                                            .call,
                                                                                        color: (astro_call_status_numero ==
                                                                                            "1")
                                                                                            ? Colors
                                                                                            .green
                                                                                            : (astro_call_status_numero ==
                                                                                            "0")
                                                                                            ? Colors
                                                                                            .black
                                                                                            : Colors
                                                                                            .red,
                                                                                      ),
                                                                                      iconSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child:

                                                                                  Ink(
                                                                                    height: 20.0,
                                                                                    decoration: const ShapeDecoration(
                                                                                      color: const Color(
                                                                                          0xffF5F5F5),
                                                                                      shape: CircleBorder(

                                                                                      ),
                                                                                    ),
                                                                                    child: IconButton(
                                                                                      padding: EdgeInsets
                                                                                          .all(
                                                                                          0.0),
                                                                                      onPressed: () {
                                                                                     //   get_wallet_balance();
                                                                                        if (astro_chat_status_numero ==
                                                                                            "1") {
                                                                                          if (wallet_balance !=
                                                                                              '0') {
                                                                                            /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;
*/
                                                                                            double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                            int final_rate = tocalculate.floor();


                                                                                            if (final_rate ==
                                                                                                2 ||
                                                                                                final_rate >
                                                                                                    2) {
                                                                                              /*Navigator.push(context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (context) {
                                                                                                      return UserChatWebview(chat_agent_id: agent_id) ;
                                                                                                    },
                                                                                                  ));*/
                                                                                              Navigator
                                                                                                  .push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (
                                                                                                        context) {
                                                                                                      return ChatDetailPage(
                                                                                                          chat_agent_id: agent_id,
                                                                                                          chat_agent_name: fullName,
                                                                                                          chat_agent_img: profileUrl,
                                                                                                          chat_fcm_token:fcmtoken
                                                                                                        // chat_agent_price: astro_price
                                                                                                      );
                                                                                                    },
                                                                                                  ));
                                                                                            }
                                                                                          }

                                                                                          else {
                                                                                            Fluttertoast
                                                                                                .showToast(
                                                                                                msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                                toastLength: Toast
                                                                                                    .LENGTH_SHORT,
                                                                                                gravity: ToastGravity
                                                                                                    .CENTER,
                                                                                                timeInSecForIosWeb: 1,
                                                                                                backgroundColor: Colors
                                                                                                    .black,
                                                                                                textColor: Colors
                                                                                                    .white,
                                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                        else
                                                                                        if (astro_chat_status_numero ==
                                                                                            "0") {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is unavailable, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        else {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is busy, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }


                                                                                        //  You enter here what you want the button to do once the user interacts with it
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons
                                                                                            .message,
                                                                                        color: (astro_chat_status_numero ==
                                                                                            "1")
                                                                                            ? Colors
                                                                                            .green
                                                                                            : (astro_chat_status_numero ==
                                                                                            "0")
                                                                                            ? Colors
                                                                                            .black
                                                                                            : Colors
                                                                                            .red,
                                                                                      ),
                                                                                      iconSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ])
                                                              ),


                                                              /*  Expanded(child:
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                                    height: 15,
                                                    width : 60 ,
                                                    child:

                                                    ElevatedButton(

                                                      child:

                                                      Text(followbuttontext, style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                                          fontSize: 8
                                                      ),),

                                                      onPressed: () {

                                                        sendfollow();

                                                        setState(() {

                                                          if(followbuttontext == 'Follow') {
                                                            followbuttontext = 'Unfollow';
                                                          }
                                                          else if(followbuttontext == 'Unfollow')
                                                          {
                                                            followbuttontext = 'Follow';
                                                          }

                                                        });


                                                      },

                                                      style: ElevatedButton.styleFrom(
                                                        onPrimary: Colors.red,
                                                        primary: const Color(0xffe22525),
                                                        onSurface: Colors.grey,

                                                      ),
                                                    ),
                                                  ),),*/
                                                            ]
                                                        ),


                                                      ),
                                                    );
                                                }
                                              }),
                                    )
                                                  : Center(child: new CircularProgressIndicator()),

                                          ),
                                        ],
                                      )
                                    )

                                  ]))),

                      //  SizedBox(height: 10),

                      //Tarot Card
                      Card(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              color: Color(0xffF8F9F9),
                              child: Column(
                                  children: <Widget>[

                                    new

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 10, 0, 0),
                                            child: Text('Tarot Card',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    fontFamily: 'Poppins')),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 15, 0),
                                            child:
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: 'View All',
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffe22525),
                                                        fontFamily: 'Poppins',
                                                      fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  Astrologers_TarotPage()),
                                                        );
                                                      }),
                                              ]),
                                            ),
                                            // Text('View All', textAlign: TextAlign.end, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15)),
                                          )
                                        ]
                                    ),

                                    SizedBox(height: 5),

                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10, 0, 10, 20),
                                      height: 220,
                                      width: double.infinity,
                                      child:
                                      Column(
                                        children: [
                                          Flexible(
                                              child: //
                                              astrologerslist_tarot.isNotEmpty

                                                  ?
                                              RefreshIndicator(
                                                onRefresh: () async {
                                                  await Future.delayed(Duration(seconds: 2));
                                                  fetchUser3();
                                                },
                                                child:
                                                GridView.builder(
                                            // scrollDirection: ,
                                             // physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 8,
                                                mainAxisExtent: 220,
                                                //childAspectRatio: 2
                                              ),
                                              itemCount: astrologerslist_tarot.length,
                                              itemBuilder: (context, index) {
                                                if (astrologerslist_tarot != null &&
                                                    astrologerslist_tarot.length !=
                                                        0) {
                                                  // key: ValueKey(astrologerslist_tarot[index].agentname);
                                                  // return getCard(astrologerslist[index]);
                                                  String agent_id = astrologerslist_tarot[index]
                                                      .ID;
                                                  String follow_param = astrologerslist_tarot[index]
                                                      .follow;
                                                  var fullName = astrologerslist_tarot[index]
                                                      .agentname;
                                                  var price = astrologerslist_tarot[index]
                                                      .b_rate;
                                                  var profileUrl = astrologerslist_tarot[index]
                                                      .image;
                                                  String avg_rating = astrologerslist_tarot[index]
                                                      .avg_rating;

                                                  var astro_chat_status_tarot =
                                                      astrologerslist_tarot[index]
                                                          .ChatStatus;
                                                  var astro_call_status_tarot =
                                                      astrologerslist_tarot[index]
                                                          .PhoneCallStatus;
                                                  astro_mobile =
                                                      astrologerslist_tarot[index]
                                                          .mob;
                                                  astro_extension =
                                                      astrologerslist_tarot[index]
                                                          .extension;

                                                  if (astrologerslist_tarot[index]
                                                      .token == null) {
                                                    fcmtoken = '';
                                                  }
                                                  else {
                                                    fcmtoken = astrologerslist_tarot[index].token;
                                                  }
                                                  if (avg_rating == null) {
                                                    double_rating = 0.0;
                                                  }
                                                  else {
                                                    double_rating =
                                                        double.parse(avg_rating);
                                                  }

                                                  return
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return AstroDescription(
                                                                    agent_id: agent_id,
                                                                    agent_follow: follow_param);
                                                              },
                                                            ));
                                                      },
                                                      child:
                                                      Container(
                                                        /* decoration:BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xffe22525),
                                            )
                                    ),*/
                                                        child:
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            //mainAxisSize: MainAxisSize.max,
                                                            children: <Widget>[

                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                                width: 110,
                                                                height: 110,
                                                                decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    //                   <--- border color
                                                                    width: 1.0,
                                                                  ),
                                                                ),

                                                                child:
                                                                CachedNetworkImage
                                                                  (
                                                                  /* imageBuilder: (context, imageProvider) => Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            image: DecorationImage(
                                                                image: imageProvider, fit: BoxFit.cover),
                                                          ),
                                                        ),*/
                                                                  //   imageBuilder: (context, imageProvider) =>
                                                                  imageUrl: "https://astroashram.com/uploads/agent/" +
                                                                      profileUrl,
                                                                  placeholder: (
                                                                      context,
                                                                      url) => new CircularProgressIndicator(),
                                                                  errorWidget: (
                                                                      context, url,
                                                                      error) =>
                                                                  new Image.asset(
                                                                      'assets/images/profile.png'),
                                                                ),

                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                                child: Text(
                                                                  fullName,
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: cf.Size.blockSizeHorizontal*2.3,
                                                                      fontWeight: FontWeight
                                                                          .w600
                                                                  ),),
                                                              ),


                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 1, 0, 0),
                                                                child: Text(
                                                                  'Rs. ' + price +
                                                                      ' /min',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                    fontSize: cf.Size.blockSizeHorizontal*2,
                                                                  ),),
                                                              ),

                                                              SizedBox(height: 3),

                                                              // Expanded(child:
                                                              Container(
                                                                width: 60,
                                                                height: 8,
                                                                alignment: Alignment
                                                                    .center,
                                                                child: RatingBar
                                                                    .builder(
                                                                  itemSize: 10,
                                                                  wrapAlignment: WrapAlignment
                                                                      .center,
                                                                  initialRating: double_rating,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating: true,
                                                                  itemCount: 5,
                                                                  ignoreGestures: true,
                                                                  unratedColor: Colors
                                                                      .grey,
                                                                  glowColor: const Color(
                                                                      0xffFFFF00),
                                                                  itemBuilder: (
                                                                      context, _) =>
                                                                      Icon(
                                                                        Icons.star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                  /*  ratingWidget: RatingWidget(
                              full: Icon(Icons.star),
                              half: Icon(Icons.star_half),
                              empty: Icon(Icons.star_border_outlined),
                            ),*/
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 1.0),

                                                                  onRatingUpdate: (
                                                                      rating) {
                                                                    //print(astro_rating);

                                                                  },
                                                                ),
                                                              ),
                                                              // ),


                                                              Center(
                                                                  child:
                                                                  Column(children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                          10, 10,
                                                                          10, 10),
                                                                      child: Table(

                                                                        children: [

                                                                          TableRow(
                                                                              children: [

                                                                                Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child:
                                                                                  Ink(
                                                                                    height: 20,
                                                                                    decoration: const ShapeDecoration(
                                                                                      color: const Color(
                                                                                          0xffF5F5F5),
                                                                                      shape: CircleBorder(),
                                                                                    ),
                                                                                    child: IconButton(
                                                                                      padding: EdgeInsets
                                                                                          .all(
                                                                                          0.0),
                                                                                      onPressed: () {
                                                                                    //    get_wallet_balance();

                                                                                        if (astro_call_status_tarot ==
                                                                                            "1") {
                                                                                          if (wallet_balance !=
                                                                                              '0') {
                                                                                            /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;
*/
                                                                                            double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                            int final_rate = tocalculate.floor();


                                                                                            if (final_rate ==
                                                                                                2 ||
                                                                                                final_rate >
                                                                                                    2) {
                                                                                              call_astrologer();
                                                                                            }
                                                                                          }
                                                                                          else {
                                                                                            Fluttertoast
                                                                                                .showToast(
                                                                                                msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                                toastLength: Toast
                                                                                                    .LENGTH_SHORT,
                                                                                                gravity: ToastGravity
                                                                                                    .CENTER,
                                                                                                timeInSecForIosWeb: 1,
                                                                                                backgroundColor: Colors
                                                                                                    .black,
                                                                                                textColor: Colors
                                                                                                    .white,
                                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                        else
                                                                                        if (astro_call_status_tarot ==
                                                                                            "0") {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is unavailable, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        else {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is busy, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        //  You enter here what you want the button to do once the user interacts with it
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons
                                                                                            .call,
                                                                                        color: (astro_call_status_tarot ==
                                                                                            "1")
                                                                                            ? Colors
                                                                                            .green
                                                                                            : (astro_call_status_tarot ==
                                                                                            "0")
                                                                                            ? Colors
                                                                                            .black
                                                                                            : Colors
                                                                                            .red,
                                                                                      ),
                                                                                      iconSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Material(
                                                                                  color: Colors
                                                                                      .transparent,
                                                                                  child:

                                                                                  Ink(
                                                                                    height: 20.0,
                                                                                    decoration: const ShapeDecoration(
                                                                                      color: const Color(
                                                                                          0xffF5F5F5),
                                                                                      shape: CircleBorder(

                                                                                      ),
                                                                                    ),
                                                                                    child: IconButton(
                                                                                      padding: EdgeInsets
                                                                                          .all(
                                                                                          0.0),
                                                                                      onPressed: () {
                                                                                    //    get_wallet_balance();
                                                                                        if (astro_chat_status_tarot ==
                                                                                            "1") {
                                                                                          if (wallet_balance !=
                                                                                              '0') {
                                                                                            /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;
*/
                                                                                            double tocalculate = double.parse(wallet_balance)/double.parse(price);

                                                                                            int final_rate = tocalculate.floor();


                                                                                            if (final_rate ==
                                                                                                2 ||
                                                                                                final_rate >
                                                                                                    2) {
                                                                                             /* Navigator.push(context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (context) {
                                                                                                      return UserChatWebview(chat_agent_id: agent_id) ;
                                                                                                    },
                                                                                                  ));*/
                                                                                              Navigator
                                                                                                  .push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (
                                                                                                        context) {
                                                                                                      return ChatDetailPage(
                                                                                                          chat_agent_id: agent_id,
                                                                                                          chat_agent_name: fullName,
                                                                                                          chat_agent_img: profileUrl,
                                                                                                          chat_fcm_token:fcmtoken
                                                                                                        // chat_agent_price: astro_price
                                                                                                      );
                                                                                                    },
                                                                                                  ));
                                                                                            }
                                                                                          }

                                                                                          else {
                                                                                            Fluttertoast
                                                                                                .showToast(
                                                                                                msg: "Insufficient wallet balance, please recharge to continue..",
                                                                                                toastLength: Toast
                                                                                                    .LENGTH_SHORT,
                                                                                                gravity: ToastGravity
                                                                                                    .CENTER,
                                                                                                timeInSecForIosWeb: 1,
                                                                                                backgroundColor: Colors
                                                                                                    .black,
                                                                                                textColor: Colors
                                                                                                    .white,
                                                                                              fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                        else
                                                                                        if (astro_chat_status_tarot ==
                                                                                            "0") {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is unavailable, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        else {
                                                                                          Fluttertoast
                                                                                              .showToast(
                                                                                              msg: "Agent is busy, please try after sometime",
                                                                                              toastLength: Toast
                                                                                                  .LENGTH_SHORT,
                                                                                              gravity: ToastGravity
                                                                                                  .CENTER,
                                                                                              timeInSecForIosWeb: 1,
                                                                                              backgroundColor: Colors
                                                                                                  .black,
                                                                                              textColor: Colors
                                                                                                  .white,
                                                                                            fontSize: cf.Size.blockSizeHorizontal*3.5,
                                                                                          );
                                                                                        }

                                                                                        //  You enter here what you want the button to do once the user interacts with it
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons
                                                                                            .message,
                                                                                        color: (astro_chat_status_tarot ==
                                                                                            "1")
                                                                                            ? Colors
                                                                                            .green
                                                                                            : (astro_chat_status_tarot ==
                                                                                            "0")
                                                                                            ? Colors
                                                                                            .black
                                                                                            : Colors
                                                                                            .red,
                                                                                      ),
                                                                                      iconSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ])
                                                              ),


                                                              //    Expanded(child:
                                                              /* Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                                    height: 12,
                                                    width : 60 ,
                                                    child:

                                                    ElevatedButton(

                                                      child:

                                                      Text(followbuttontext, style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                                          fontSize: 8
                                                      ),),

                                                      onPressed: () {

                                                        sendfollow();

                                                        setState(() {

                                                          if(followbuttontext == 'Follow') {
                                                            followbuttontext = 'Unfollow';
                                                          }
                                                          else if(followbuttontext == 'Unfollow')
                                                          {
                                                            followbuttontext = 'Follow';
                                                          }

                                                        });


                                                      },

                                                      style: ElevatedButton.styleFrom(
                                                        onPrimary: Colors.red,
                                                        primary: const Color(0xffe22525),
                                                        onSurface: Colors.grey,

                                                      ),
                                                    ),
                                                  ),*/
                                                              //    ),
                                                            ]
                                                        ),


                                                      ),
                                                    );
                                                }
                                              }),
                                    )
                                                  : Center(child: new CircularProgressIndicator()),

                                          ),
                                        ],
                                      )
                                    )

                                  ]))),

                      SizedBox(height: 10),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text('Client Testimonials',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: cf.Size.blockSizeHorizontal*3.5,
                                      fontFamily: 'Poppins')),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                              child:
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'View All',

                                      style: TextStyle(
                                          color: const Color(0xffe22525),
                                          fontFamily: 'Poppins',
                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TestimonalPage()),
                                          );
                                        }),
                                ]),
                              ),
                              // Text('View All', textAlign: TextAlign.end, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15)),
                            )
                          ]
                      ),

                      Container(
                        height: 155,
                        width: 370,

                        child: Card(


                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  'https://astroashram.com/uploads/agent/2272d834cfd1a9569c3f0fb7467c9a0e.jpg'),
                            ),


                            title: Text(
                              "Manvi Mishra", textAlign: TextAlign.left,
                              style: TextStyle(fontSize:  cf.Size.blockSizeHorizontal*2.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),),
                            subtitle:

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    RatingBar(
                                      itemSize: 14,
                                      wrapAlignment: WrapAlignment.center,
                                      initialRating: 3,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      unratedColor: Colors.white,
                                      glowColor: const Color(0xffb986ef),
                                      ratingWidget: RatingWidget(
                                        full: Icon(Icons.star),
                                        half: Icon(Icons.star_half),
                                        empty: Icon(Icons.star_border_outlined),
                                      ),
                                      itemPadding: EdgeInsets.symmetric(
                                          horizontal: 1.0),

                                      onRatingUpdate: (rating) {
                                        print(rating);

                                        feedback_rating = rating as String;
                                      },
                                    ),

                                  ],
                                ),
                                Text(
                                  'Asccology is the best place for people with mental health issues. They provide a deep detailed counselling without any judgement. I have a more positive approach towards life now.',
                                  style: TextStyle(fontSize: cf.Size.blockSizeHorizontal*2.5,
                                      color: Colors.black,
                                      fontFamily: 'Poppins'),
                                    maxLines: 3),

                              ],),


                          ),
                          //  elevation: 5,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.red)
                          ),
                          margin: EdgeInsets.all(20),
                        ),
                      ),

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
                                    child: Text('Why Astroashram?',
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

                      //commented because client told

                      /*  Container(
                      color: Colors.blueAccent,

                      child:

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
*/

                      //   SizedBox(height: 20),

                      //commented because client told

                      /* Container(
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
                    ),*/

                      //  ),


                    ],
                  ),
                  //  ),],),
                  //  ),
                ),
                // ),
              )
          )
      );


    //);
  }


  void getqueueagent () async {

    setState(() {
      isLoading = true;
    });
    var _loginApiClient = LoginApiClient();
    AstrologerRequestModel astrologerRequestModel = AstrologerRequestModel();
    astrologerRequestModel.agent_id = got_agent_id;

    AgentStatusListingResponse userModel =
    await _loginApiClient.getcallstatus(astrologerRequestModel);

    print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (userModel.status == true) {
      print(userModel.data);

      setState(() {
        isLoading = false;
      });
      agent_status = userModel.data[0].agentstatus.toString();
      print('status'+agent_status);

      if(agent_status == 'READY')
      {
        is_agentavailable = true;
        /*  setState(() {
            is_agentavailable = true;
          });
*/
      }
      else if(agent_status == 'CONNECT')
      {
        is_agentavailable = false;
        /*  setState(() {
            is_agentavailable = false;
          });
*/

      }


    }
    else {

      setState(() {

        isLoading = false;
      });

      is_agentavailable = null;

      print(userModel.message);
    }


  }


  fetchUser1() async {
    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');
    print(session_user_id);

    LoginApiClient api = LoginApiClient();
    AstroRequestModel requestModel = new AstroRequestModel();

    requestModel.search = '';
    requestModel.price = '';
    requestModel.expertise = '';
    requestModel.service_id = '1';
    requestModel.user_id = session_user_id;

    astrologerslist_psycho = await api.getastrologersdata(requestModel);
    setState(() {
      // astrologerslist = items;
      // searchlist = items;
      isLoading = false;
    });
  }

  call_user_low_balance () async {

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    LoginApiClient api = LoginApiClient();
    AvailableAgentRequestModel requestModel = new AvailableAgentRequestModel();

    requestModel.service = '4';
    requestModel.user_id = session_user_id;


    astrologerslist_available = await api.getavailableagent(requestModel);
    setState(() {
      // astrologerslist = items;
      // searchlist = items;
      isLoading = false;
    });
  }



  get_agent_available() async {
    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    LoginApiClient api = LoginApiClient();
    AvailableAgentRequestModel requestModel = new AvailableAgentRequestModel();

    requestModel.service = '4';
    requestModel.user_id = session_user_id;


    astrologerslist_available = await api.getavailableagent(requestModel);
    setState(() {
      // astrologerslist = items;
      // searchlist = items;
      isLoading = false;
    });
  }


  getservices() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(AppUrl.get_services);
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['services'];
      setState(() {
        servicelist = items;
        isLoading = false;
      });
    }else{
      servicelist = [];
      isLoading = false;
    }
  }


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
      session_user_id = logindata.getString('user_id');
      session_user_mobile = logindata.getString('user_mobile');
      session_user_password = logindata.getString('user_password');

    /*  Fluttertoast.showToast(
        msg: session_user_id,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize:  cf.Size.blockSizeHorizontal * 3.5,
      );*/
      //print(session_user_id);
    });
  }



  getpremiumastrologers() async {

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');


    LoginApiClient api = LoginApiClient();
    UserRequestModel requestModel = new UserRequestModel();
    requestModel.user_id = session_user_id;

    premiumlist = await api.getpremiumdata(requestModel);


      setState(() {
        //premiumlist = premiumlist;
      });


  }


  fetchUser2() async {
    setState(() {
      isLoading = true;
    });

   logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    LoginApiClient api = LoginApiClient();
    AstroRequestModel requestModel = new AstroRequestModel();

    requestModel.search = '';
    requestModel.price = '';
    requestModel.expertise = '';
    requestModel.service_id = '2';
    requestModel.user_id = session_user_id;

    astrologerslist_numero = await api.getastrologersdata(requestModel);
    setState(() {
      // astrologerslist = items;
      // searchlist = items;
      isLoading = false;
    });
  }


  fetchUser3() async {
    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    LoginApiClient api = LoginApiClient();
    AstroRequestModel requestModel = new AstroRequestModel();

    requestModel.search = '';
    requestModel.price = '';
    requestModel.expertise = '';
    requestModel.service_id = '3';
    requestModel.user_id = session_user_id;
  //  print(session_user_id);

    astrologerslist_tarot = await api.getastrologersdata(requestModel);
    setState(() {
      // astrologerslist = items;
      // searchlist = items;
      isLoading = false;
    });
  }


  fetchUser4() async {

    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    LoginApiClient api = LoginApiClient();
    AstroRequestModel requestModel = new AstroRequestModel();

    requestModel.search = '';
    requestModel.price = '';
    requestModel.expertise = '';
    requestModel.service_id = '4';
    requestModel.user_id = session_user_id;

    astrologerslist_astrology = await api.getastrologersdata(requestModel);
    setState(() {
      // astrologerslist = items;
      // searchlist = items;
      isLoading = false;
    });
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
      feedbackModel.user_id = session_user_id;
      feedbackModel.description = feedback_desc ;


      SendFeedbackResponse userModel =
      await _loginApiClient.send_user_feedback(feedbackModel);

      print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
      // (data?.isEmpty ?? true
      //  if (userModel?.status ?? true) {
      //   if (userModel!=null) {

     // if (userModel.status == true) {
        print('Feedback sent successfully');

        //    feedbackdesccontroller.text('');

        Fluttertoast.showToast(
            msg: "Feedback sent successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize:  cf.Size.blockSizeHorizontal * 3.5,
        );

        feedbackdesccontroller.text = '';


     /* }
      else
      {
        print('Feedback sending failed');
      }*/

    }
  }

  call_astrologer_psycho() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post('https://astroashram.com/call_api/callapi.php?extension='+session_user_mobile+'&code='+agent_ext+'&submit=call');
    // print(response.body);
    if(response.statusCode == 200){

      Fluttertoast.showToast(
          msg: "Calling...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize:  cf.Size.blockSizeHorizontal * 3.5,
      );
      // var ite ms = json.decode(response.body)['data'];
      setState(() {
        //   astrologerslist = items;
        //  isLoading = false;
      });
    }else{
      //  astrologerslist = [];
      //  isLoading = false;
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
