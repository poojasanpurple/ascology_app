import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_follow_request.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/astro_request.dart';
import 'package:ascology_app/model/request/review_request_model.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/AgentStatus_Response.dart';
import 'package:ascology_app/model/response/astrologer_agentstatus.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:ascology_app/model/response/check_follow_user_response.dart';
import 'package:ascology_app/model/response/followers_response.dart';
import 'package:ascology_app/model/response/my_wallet_response.dart';
import 'package:ascology_app/model/response/review_response.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/screens/chat_detail.dart';
import 'package:ascology_app/screens/user_chat_webview.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/screens/user_profile.dart';
import 'package:ascology_app/screens/video_call_page.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;



class AstroDescription extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  String agent_id,agent_name,agent_img,agent_follow;

 // AstroDescription({this.agent_id,this.agent_name,this.agent_img});
  AstroDescription({this.agent_id,this.agent_follow});

  @override
  _AstroDescriptionState createState() => _AstroDescriptionState();
}

class _AstroDescriptionState extends State<AstroDescription> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = false;
  String got_agent_id,got_img,got_agent_name,got_follow_param,review_desc;
  String astro_rating,session_user_id;
      String wallet_balance = '0';
  List astrologerslist = [];
  List<String> astroimages;
  int activePage = 1;
  double required_rate;

  bool following = false;
  PageController _pageController;

  String astro_services,astro_timing,astro_experience,astro_extension,astro_language,astro_img,astro_shortdesc,session_user_mobile,
      astro_agentname,astro_mobile,follower_count='0',check_agent_id,agent_status,astro_price,astro_chat_status,astro_call_status;
  var astro_about;
  double ast_rating;
  String send_rating;
  SharedPreferences logindata;
  var double_rating = 0.0;
  var followbuttontext;
  var unfollowbuttontext = 'Following';
  TextEditingController review_controller = TextEditingController();


  List<FollowersDetails> followerlist = List();
  List<CheckFollowUser> checkfollowlist = List();

  bool buttonenabled = false;
  bool is_agentavailable = false;

  _startLoading() {
    setState(() {
      isLoading = true;
    });

    Timer(const Duration(seconds: 8), () {
      setState(() {
        isLoading = false;
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getConnectivity();
    got_agent_id = widget.agent_id;
    got_follow_param = widget.agent_follow;

    if(got_follow_param == "yes")
    {
      followbuttontext = "Following";
    }
    else if(got_follow_param == "no")
    {
      followbuttontext = "Follow";
    }


    print(got_agent_id);
      _pageController = PageController(viewportFraction: 0.8);


    _startLoading();
    fetch_agent_details();
    getfollowerscount();
    get_wallet_balance();


   // getqueueagent();

    // to check whether user is following the agent whichever he opens
    // to show the folloe button or grey out
 //   checkfollowuser();

  //  this.getimages();
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
       /* if (details.data != null) {
          wallet_balance = details.data[0].amount.toString();
          print('wallet_balance' + wallet_balance);


        //  wallet_balance = details.data[0].amount.toString();
          *//*  if(wallet_balance == null) {

        print(wallet_balance);
        wallet_balance = '0';
      }
      else
      {
        wallet_balance = details.data[0].amount.toString();
      }*//*
        }

        else {
          wallet_balance = '0';
        }*/
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



  @override
  Widget build(BuildContext context) {

    cf.Size.init(context);


    const rowSpacer=TableRow(
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          )
        ]);

    return SafeArea(
        child:
        Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
          title: Text('AstroAshram', style: TextStyle(
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

          body:

          SafeArea(child:
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                :


          SingleChildScrollView(
            child:

            Column(
              children: [
                Container(
                  width: cf.Size.screenWidth,
                 // height: cf.Size.screenHeight,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      //  height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.
      //width: MediaQuery.of(context).size.width,
      child:
      //  padding: EdgeInsets.all(20),
      /*Flex( direction: Axis.vertical,
                  children: [
                  Expanded(*/
      /*Flexible(
        child:*/
        Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: 280,
                          height:280,
                          child:

                          CachedNetworkImage
                            (imageUrl : "https://astroashram.com/uploads/agent/"+astro_img,
                            placeholder: (context, url) => new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Image.asset('assets/images/profile.png'),
                          ),
                        ),

                       /* Container(
                          width: 100,
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                         alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: cdouble_ratingonst BorderRadius.all(Radius.circular(40)),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/getnow.png'),
                                fit: BoxFit.cover
                            ),
                          ), // button text
                          child: Text("Joint",textAlign: TextAlign.center, style: TextStyle(
                              fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,


                          ),),
                        ),*/
                      ]
                  ),

                  SizedBox(height: 10),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[

                        Container(
                          width: cf.Size.screenWidth,
                     // height: cf.Size.screenHeight, ,
                          height: cf.Size.screenHeight/10,
                          alignment: Alignment.center,

                          child: Text(astro_agentname.toString(),maxLines:2,textAlign: TextAlign.center, style: TextStyle(
                            fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                            fontSize: cf.Size.blockSizeHorizontal*6,
                            color: Colors.black,


                          ),),
                        ),
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[

                        Container(
                          width: cf.Size.screenWidth/2,
                          // height: cf.Size.screenHeight, ,
                          height: cf.Size.screenHeight/30,
                         // width:300 ,
                        //  height: 20,
                          alignment: Alignment.center,

                          child:  RatingBar.builder(
                            itemSize: 20,
                            wrapAlignment: WrapAlignment.center,
                            initialRating: double_rating,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            glowColor: const Color(0xffFFFF00),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),

                          /*  ratingWidget: RatingWidget(
                              full: Icon(Icons.star),
                              half: Icon(Icons.star_half),
                              empty: Icon(Icons.star_border_outlined),
                            ),*/
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),

                            onRatingUpdate: (rating) {
                              print(astro_rating);
                              /*setState(() {
                               // double_rating = rating;
                              });*/
                            },
                          ),
                        ),
                      ]
                  ),


                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[


                        Container(

                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          //  width:,
                          height: 30,
                          alignment: Alignment.centerRight,

                          child:

                          ElevatedButton(

                            child:

                            Text(followbuttontext, style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                fontSize: cf.Size.blockSizeHorizontal * 3,
                            ),),

                            onPressed: () {


                              sendfollow();

                              setState(() {


                              });

                              getfollowerscount();

                            },

                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: const Color(0xffe22525),
                              onSurface: Colors.grey,

                            ),
                          ),

                       ),




                      ]
                  ),



                  Row(
                    children: [
                      Center(
                        child: Container
                          (width: cf.Size.screenWidth,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            height: 30,
                            child: Text(follower_count +'  followers', textAlign:TextAlign.center,style: TextStyle(fontFamily: 'Poppins', fontSize:  cf.Size.blockSizeHorizontal * 4,color: const Color(0xffe22525)
                                ,fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),


                  Wrap(children:<Widget>[
                          Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    width: cf.Size.screenWidth,
                    child: Center(
                        child: Column(children: <Widget>[
                         /* Container(
                            margin: EdgeInsets.all(10),*/
                          Padding(
                            padding: const EdgeInsets.all(12.0),

                            child: Table(
                             // border: TableBorder.all(),
                              children: [
                                TableRow( children: [

                                    Text('Service'),


                                    Text(':',textAlign: TextAlign.center),

                                    Text(astro_services.toString()),

                                ]),

                                rowSpacer,
                                TableRow( children: [

                                    Text('Experience'),

                                  Text(':',textAlign: TextAlign.center),

                                    Text(astro_experience.toString()+ ' years'),

                                ]),
                               /* rowSpacer,
                                TableRow( children: [

                                    Text('Expertise'),

                                  Text(':',textAlign: TextAlign.center),

                                    Text(astro_shortdesc.toString()),

                                ]),*/
                                rowSpacer,
                                TableRow( children: [

                                    Text('Availability'),

                                  Text(':',textAlign: TextAlign.center),

                                    Text(astro_timing.toString()),

                                ]),
                                rowSpacer,
                                TableRow( children: [

                                  Text('Price'),

                                  Text(':',textAlign: TextAlign.center),

                                  Text('Rs. '+astro_price.toString()+' /minute'),

                                ]),
                                rowSpacer,
                                TableRow( children: [

                                    Text('Extension'),

                                  Text(':',textAlign: TextAlign.center),

                                    Text(astro_extension.toString()),

                                ]),
                                rowSpacer,
                              ],
                            ),
                          ),
                         // ),
                        ])
                    ),
                  ),],),
                  SizedBox(height: 10),

                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: const Color(0xffe22525),
                  ),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[


                          IconButton(
                            // minWidth: 25.0,
                            iconSize: 30,
                            icon: Icon(Icons.message),
                          //  color: const Color(0xffe22525),
                            color: (astro_chat_status=="1")?Colors.green:(astro_chat_status=="0")?Colors.black:Colors.red,

                            /* shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),*/
                            onPressed: () {

                             /* Navigator.pushReplacement(context,new MaterialPageRoute(builder:
                                  (context) => ChatDetailPage()));*/

                             // get_wallet_balance();
                              if (astro_chat_status ==
                                  "1") {


                                if (wallet_balance !=
                                    '0') {


                                  print(wallet_balance);

                                  double tocalculate = double.parse(wallet_balance)/double.parse(astro_price);

                                  int final_rate = tocalculate.floor();

                                  /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;



*/

                                  //print(required_rate.toString());




                                  // var myprice = int.parse(price);
                                  /*  required_rate =
                                                                              wallet_balance /
                                                                                  price;
*/


                                  if (final_rate ==
                                      2 ||
                                      final_rate >
                                          2) {
                                    /* Navigator
                                                                                .push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (
                                                                                      context) {
                                                                                    return ChatDetailPage(
                                                                                        chat_agent_id: agent_id,
                                                                                        chat_agent_name: fullName,
                                                                                        chat_agent_img: profileUrl
                                                                                      // chat_agent_price: astro_price
                                                                                    );
                                                                                  },
                                                                                ));*/

                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return UserChatWebview(chat_agent_id: got_agent_id) ;
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
                                      fontSize: 16.0
                                  );
                                }
                              }
                              else
                              if (astro_chat_status ==
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
                                    fontSize: 16.0
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
                                    fontSize: 16.0
                                );
                              }
                            },
                          ),
                          Text('Chat',textAlign: TextAlign.center, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 12,fontFamily: 'Poppins'))
                        ],),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            // minWidth: 25.0,
                            iconSize: 30,
                          //  color: (is_agentavailable==true)?Colors.green:(is_agentavailable==false)?Colors.red:Colors.black,
                            color: (astro_call_status=="1")?Colors.green:(astro_call_status=="0")?Colors.black:Colors.red,
                            icon: Icon(Icons.call),
                            /* shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),*/
                            onPressed: () {

                              if (astro_call_status ==
                                  "1") {


                                if (wallet_balance !=
                                    '0') {


                                  print(wallet_balance);
                                //  print(price.toString());

                                  double tocalculate = double.parse(wallet_balance)/double.parse(astro_price);

                                  int final_rate = tocalculate.floor();

                                  /* var int_wallet = double.parse(wallet_balance);
                                                                    var int_price = double.parse(price);
                                                                    required_rate =  int_wallet/int_price;



*/

                                  //print(required_rate.toString());




                                  // var myprice = int.parse(price);
                                  /*  required_rate =
                                                                              wallet_balance /
                                                                                  price;
*/


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
                                      fontSize: 16.0
                                  );
                                }
                              }
                              else
                              if (astro_call_status ==
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
                                    fontSize: 16.0
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
                                    fontSize: 16.0
                                );
                              }




                      //        https://asccology.com/call_api/callapi.php?extension=$mobile_num&code=$extension&submit=call

                            },
                          ),
                          Text('Call',textAlign: TextAlign.center, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 12,fontFamily: 'Poppins'))
                        ],
                      ),


                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            // minWidth: 25.0,
                            iconSize: 30,
                            color: const Color(0xffe22525),
                            icon: Icon(Icons.video_call),
                            /* shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),*/
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VideoCallPage()),
                              );

                            },
                          ),
                          Text('Video Call',textAlign: TextAlign.center, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 12,fontFamily: 'Poppins'))
                        ],),




                    ],
                  ),

                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: const Color(0xffe22525),
                  ),


                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                  Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child:
                        Column(

                          children: <Widget>[
                            Wrap(children:<Widget>[
                              Container(
                              width: MediaQuery.of(context).size.width,
                             // height: 30,
                              margin: EdgeInsets.fromLTRB(20, 20, 0, 0 ),
                              //  alignment: Alignment.center,

                              child: Text("Profile Summary",textAlign: TextAlign.left, style: TextStyle(
                                fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,

                              ),),
                            ),
                            ],
                            ),

        Wrap(children:<Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                             // height: MediaQuery.of(context).size.height/4,
                              margin: EdgeInsets.fromLTRB(20, 10, 10, 0 ),
                              //  alignment: Alignment.center,

                             // child: Text(Html(data:astro_about),textAlign: TextAlign.left, style: TextStyle(
                              child: Html(data:astro_about)),

                  ],),
                          ],
                        ),),),


                      ]
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child:
                            Column(

                              children: <Widget>[

                            Wrap(children:<Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                 // height: 30,
                                  margin: EdgeInsets.fromLTRB(20, 20, 0, 0 ),
                                  //  alignment: Alignment.center,

                                  child: Text("Expertise ",textAlign: TextAlign.left, style: TextStyle(
                                    fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,

                                  ),),
                                ),
                                ],),
        Wrap(children:<Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                 //   height: MediaQuery.of(context).size.height/4,
                                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20 ),
                                    //  alignment: Alignment.center,

                                    child: Text(astro_shortdesc,textAlign: TextAlign.left, style: TextStyle(
                                    )
                                    )
                                )

          ],),
                              ],
                            ),),),


                      ]
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child:
                            Column(

                              children: <Widget>[


                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    // height: 30,
                                    margin: EdgeInsets.fromLTRB(20, 15, 0, 0 ),
                                    //  alignment: Alignment.center,

                                    child: Text("Write your own review ",textAlign: TextAlign.left, style: TextStyle(
                                      fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,

                                    ),),
                                  ),

                             //   Wrap(children:<Widget>[
                                  /*Container(
                                      width: MediaQuery.of(context).size.width,
                                      //   height: MediaQuery.of(context).size.height/4,
                                      margin: EdgeInsets.fromLTRB(20, 10, 10, 20 ),
                                      //  alignment: Alignment.center,

                                      child: Text(astro_shortdesc,textAlign: TextAlign.left, style: TextStyle(
                                      )
                                      )
                                  )*/


                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20 ),
                                    //  alignment: Alignment.center,
                                    child: RatingBar
                                        .builder(
                                      itemSize: 20,
                                      wrapAlignment: WrapAlignment
                                          .center,
                                      initialRating: 0.0,
                                      direction: Axis
                                          .horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      ignoreGestures: false,
                                      unratedColor: Colors
                                          .grey,
                                      glowColor: const Color(
                                          0xffFFFF00),
                                      itemBuilder: (
                                          context,
                                          _) =>
                                          Icon(
                                            Icons
                                                .star,
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
                                        print(rating);
                                        send_rating = rating.toString();
                                        print(send_rating);


                                      },
                                    ),
                                  ),

                                  Container(
                                    width:  cf.Size.screenWidth,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: TextFormField(
                                      autofocus: false,
                                      maxLines: 5,
                                      style: TextStyle(color: Colors.black,fontFamily: 'Poppins'),
                                      decoration: InputDecoration(fillColor: Colors.black12, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
                                      )),
                                      validator: (value) =>
                                      value.isEmpty ? "Please enter your review" : null,
                                      onSaved: (value) => review_desc = value,
                                      controller: review_controller,

                                    ),
                                  ),

                                  Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Center(
            child: ElevatedButton(
              child: Text('Send review'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                // side: BorderSide(color: Colors.yellow, width: 5),
                textStyle: const TextStyle(
                    color: Colors.white, fontSize: 15, fontFamily: 'Poppins'),
                shadowColor: Colors.redAccent,
              ),
              onPressed: ()
              {
              send_review();
            }
            ),
          ),
        )

                              //  ],),
                              ],
                            ),),),


                      ]
                  ),


                  /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child:
                            Column(

                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30,
                                  margin: EdgeInsets.fromLTRB(20, 20, 0, 0 ),
                                  //  alignment: Alignment.center,

                                  child: Text("Image Gallery",textAlign: TextAlign.left, style: TextStyle(
                                    fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,

                                  ),),
                                ),



                              ],
                            ),),),


                      ]
                  ),*/

                 /* SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child:   PageView.builder(
                        itemCount: astroimages.length,
                        pageSnapping: true,
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            activePage = page;
                          });
                        },
                        itemBuilder: (context, pagePosition) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Image.network('https://asccology.com/uploads/agent/'+astroimages[pagePosition],fit: BoxFit.cover),
                          );
                        }),
                  ),*/
                /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child:
                            Column(

                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30,
                                  margin: EdgeInsets.fromLTRB(20, 20, 0, 0 ),
                                  //  alignment: Alignment.center,

                                  child: Text("Video Gallery",textAlign: TextAlign.left, style: TextStyle(
                                    fontFamily: 'Poppins',fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,

                                  ),),
                                ),



                              ],
                            ),),),


                      ]
                  ),*/

                ],
          ),
    //),
          ),
              ],
            ),




          ),
          ),
        )




),
        );



   // print('data:'+astrologerDetails.)



  }

  call_astrologer() async {

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');
    session_user_mobile = logindata.getString('user_mobile');

    setState(() {
     // isLoading = true;
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
          fontSize: 16.0
      );


      Fluttertoast.showToast(
          msg: "You will receive a call from Astroashram in few minutes...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );




      // var ite ms = json.decode(response.body)['data'];
      setState(() {
     //   astrologerslist = items;
      //  isLoading = false;
      });
    }else{
    //  astrologerslist = [];
    //  isLoading = false;
      Fluttertoast.showToast(
          msg: "Unable to connect to Astroashram...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  void send_review() async {
    //review_desc  = '';

    review_desc = review_controller.text;
    //  if (_userName.length !=10) {
    if (review_desc != null) {
      //  loaderFun(context, true);
      var _loginApiClient = LoginApiClient();
      // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
      ReviewRequestModel feedbackModel =  ReviewRequestModel();
      //_userName,_password,'1234','','',apkversion,'');
      feedbackModel.comment = review_desc;
      feedbackModel.agent_id = got_agent_id ;
      feedbackModel.current_user = session_user_id ;
      feedbackModel.rating =  send_rating;


      ReviewResponseModel userModel =
      await _loginApiClient.send_review(feedbackModel);

      print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
      // (data?.isEmpty ?? true
      //  if (userModel?.status ?? true) {
      //   if (userModel!=null) {

       if (userModel.status == true) {
      print('Feedback sent successfully');

      //    feedbackdesccontroller.text('');

      Fluttertoast.showToast(
          msg: userModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      review_controller.text = '';


      }
      else
      {
        Fluttertoast.showToast(
            msg: "Please fill all review sections",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print('Feedback sending failed');
      }

    }
  }


  void fetch_agent_details() async {

    setState(() {
      isLoading = true;
    });
    print(got_agent_id);
        var _loginApiClient = LoginApiClient();
        AstrologerRequestModel astrologerRequestModel = AstrologerRequestModel();
        astrologerRequestModel.agent_id = got_agent_id;

        AstrologerListingResponse userModel =
        await _loginApiClient.getastrologerdetails(astrologerRequestModel);

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
          astro_services = userModel.data[0].title.toString();
          astro_timing = userModel.data[0].timing.toString();
          astro_experience = userModel.data[0].experience.toString();
          astro_extension = userModel.data[0].extension.toString();
          astro_language = userModel.data[0].id_language.toString();
          astro_img = userModel.data[0].image;


          /*  if(astro_img!=null)
          {

            astro_img = userModel.data[0].image;
          }
          else
          {
            astro_img = '${astro_img}';
          }
*/
          astro_about = userModel.data[0].about.toString();
          astro_shortdesc = userModel.data[0].short_description.toString();
          astro_agentname = userModel.data[0].agentname.toString();
          astro_mobile = userModel.data[0].mob.toString();
          astro_rating = userModel.data[0].avg_rating.toString();
          astro_price = userModel.data[0].price.toString();
          astro_chat_status = userModel.data[0].ChatStatus.toString();
          astro_call_status = userModel.data[0].PhoneCallStatus.toString();

          if(astro_call_status == '1')
          {
            is_agentavailable = true;

          }
          else if(astro_call_status == '0')
          {
            is_agentavailable = false;

          }
          else {

          is_agentavailable = null;

          print(userModel.message);
        }


    if(astro_rating == null)
            {
              double_rating = 0.0;
            }
          else
            {
             // double
              double_rating = double.parse(astro_rating);
            }


         // print(astro_rating);
         // ast_rating = astro_rating as double;

        //  String a = AstrologerDetails.fromJson(userModel.data).agentname;


        /*  AstrologerDetails details = AstrologerDetails();
          details.agentname = userModel.data.asMap()
*/
        }
        else {

          setState(() {

            isLoading = false;
          });
          print(userModel.message);
        }
      }

  void getimages() async {
    var _loginApiClient = LoginApiClient();
    AstrologerRequestModel astrologerRequestModel = AstrologerRequestModel();
    astrologerRequestModel.agent_id = got_agent_id;

    AstrologerListingResponse userModel =
    await _loginApiClient.getastroimages(astrologerRequestModel);

    print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (userModel.status == true) {
      print(userModel.data);
      var items = userModel.data;
      int imgcount = userModel.data.length;

      setState(() {
        astrologerslist = items;
        isLoading = false;
      });

      
      for(int i =0;i<imgcount;i++) {
        astroimages.add(astrologerslist[i]['image']) ;
      }
      //  String a = AstrologerDetails.fromJson(userModel.data).agentname;


      /*  AstrologerDetails details = AstrologerDetails();
          details.agentname = userModel.data.asMap()
*/
    }
    else {
      print(userModel.message);
    }
  }

  void sendfollow() async {
   /* setState(() {
      isLoading = true;
    });*/
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');


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
     /* Fluttertoast.showToast(
          msg: "Sending update...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
*/
      if(followbuttontext == 'Follow') {
        followbuttontext = 'Following';
      }
      else if(followbuttontext == 'Following')
      {
        followbuttontext = 'Follow';
      }

      Fluttertoast.showToast(
          msg: userModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
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

  void getfollowerscount() async{


    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');


   // var _loginApiClient = LoginApiClient();
    // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
    AgentRequestModel requestModel = AgentRequestModel();
    //_userName,_password,'1234','','',apkversion,'');
    requestModel.agent_id = got_agent_id;

    LoginApiClient api = LoginApiClient();

    followerlist = await api.getcountoffollowers(requestModel);


    setState(() {
      followerlist = followerlist;
    });

    if(followerlist==null && followerlist.length==0)
      follower_count = '0';
    else {
     follower_count = followerlist.length.toString();
    }
    
    

      /*  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHomePage()),
      );*/
    }


  void checkfollowuser() async {

    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
    UserRequestModel requestModel = UserRequestModel();
    //_userName,_password,'1234','','',apkversion,'');
    requestModel.user_id = session_user_id;

    LoginApiClient api = LoginApiClient();

    checkfollowlist = await api.checkfollowagent(requestModel);

    setState(() {
      checkfollowlist = checkfollowlist;
    });

    if(checkfollowlist!=null && checkfollowlist.length!=0)
      {
        for(int i = 0; i<=checkfollowlist.length;i++)
          {
            check_agent_id = checkfollowlist[i].agent_id.toString();
            if(got_agent_id == check_agent_id)
              {
                setState(() {
                  Fluttertoast.showToast(
                      msg: "Equal",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                  following = false;
                });

                //buttonenabled = false;

              }
            else
              {

                setState(() {
                  Fluttertoast.showToast(
                      msg: "Not equal",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                  following = true;
                });

                //buttonenabled = true;
              }
          }
      }
    else
      {

      }


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


  }




