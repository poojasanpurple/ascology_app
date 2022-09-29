import 'dart:async';
import 'dart:convert';
import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_follow_request.dart';
import 'package:ascology_app/model/request/astro_category_model.dart';
import 'package:ascology_app/model/request/astro_request_model.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/check_follow_user_response.dart';
import 'package:ascology_app/model/response/my_wallet_response.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/screens/astrologer_desc_page.dart';
import 'package:ascology_app/screens/chat_detail.dart';
import 'package:ascology_app/screens/user_chat_webview.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;



class Astrologers_TarotPage extends StatefulWidget {


  // UserVerifyOtp({this.mobile,this.usertype});



  @override
  _Astrologers_TarotPageState createState() => _Astrologers_TarotPageState();
}

class _Astrologers_TarotPageState extends State<Astrologers_TarotPage> {
  List<String> prob_areas = ["All","Gemstone", "Education", "Vastu", "Remedies", "House Number", "Mental Health",
    "Stock Market","Finance","Family Life","Marriage","Legal Matters","Decoding Dreams",
    "Love","Wealth & Property","Government Job","Vehicle Number","Child Birth","Foreign Travel","Health","Shubh Muhurta",
    "Mobile Number","Carrier & Business"];
  // List astrologerslist = [];
  List<AstrologerDetails> astrologerslist = List();
  List<AstrologerDetails> searchlist = List();
  List<String> followlist = [];
  String selected_category;
  int selectedIndex;
  SharedPreferences logindata;
//  List searchlist = [];
  bool isLoading = false;
  var wallet_balance ;
  var required_rate;
  String send_agent_id,astro_mobile, astro_extension,selectedagent_id;
  double double_rating = 0.0;
  var followbuttontext = 'Follow';
  var unfollowbuttontext = 'Following';
  bool following = false;
  String check_agent_id;

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  List<CheckFollowUser> checkfollowlist = List();
  String got_agent_id,astro_agentname,astro_img,session_user_id,session_user_mobile;
  // final AstrologerDetails astrologerDetails;

  Widget appBarTitle = Text(
    "Tarot Card",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();



  _startLoading() {
    setState(() {
      isLoading = true;
    });

  /*  Timer(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startLoading();

    getConnectivity();
    this.fetchUser();
    get_wallet_balance();
  //  checkfollowuser();
    searchlist = astrologerslist;
    //_IsSearching = false;

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


  void sendfollow(String agent_id) async {
    /* setState(() {
      isLoading = true;
    });*/
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');


    var _loginApiClient = LoginApiClient();
    // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
    AgentFollowRequestModel requestModel = AgentFollowRequestModel();
    //_userName,_password,'1234','','',apkversion,'');
    requestModel.agent_id = agent_id;
    requestModel.user_id = session_user_id;
    UserChangePasswordResponseModel userModel =
    await _loginApiClient.sendfollowagent(requestModel);

    if(userModel.status == true) {

      print('Following...');
      Fluttertoast.showToast(
          msg: userModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Astrologers_TarotPage()), // this mymainpage is your page to refresh
        // (Route<dynamic> route) => false,
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


  fetchUser() async {

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

    astrologerslist = await api.getastrologersdata(requestModel);
    setState(() {
      astrologerslist = astrologerslist;
      searchlist = astrologerslist;
      isLoading = false;
    });




/*
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
    }*/
  }

  call_astrologer() async {
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');
    session_user_mobile = logindata.getString('user_mobile');

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
    }
  }

  void getcategorywiselist() async{

    LoginApiClient api = LoginApiClient();
    AstroCategoryRequestModel requestModel = new AstroCategoryRequestModel();

    requestModel.expertise = selected_category;
    requestModel.service_id = '4';

    astrologerslist = await api.getcategorywisedata(requestModel);
    setState(() {
      astrologerslist = astrologerslist;
      searchlist = astrologerslist;
      isLoading = false;
    });




/*
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
    }*/
  }

/*
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
      print(checkfollowlist.toString());
    });

    if(checkfollowlist!=null && checkfollowlist.length!=0)
    {
      for(int i = 0; i<=checkfollowlist.length;i++)
      {

        followlist.add(checkfollowlist[i].agent_id);
      //  check_agent_id = checkfollowlist[i].agent_id.toString();

      }

      for(int j=0;j<=followlist.length;j++)
        {
          if(selectedagent_id == followlist[j])
          {
            setState(() {
              */
/* Fluttertoast.showToast(
                      msg: "Equal",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*//*

              following = true;
            });

            //buttonenabled = false;

          }
          else
          {

            setState(() {
              */
/* Fluttertoast.showToast(
                      msg: "Not equal",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*//*

              following = false;
            });

            //buttonenabled = true;
          }
        }

    }
    else
    {

    }



  }
*/


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

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = astrologerslist;
    } else {
      results = astrologerslist
          .where((user) =>
          user.agentname.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchlist = results;
    });
  }

  @override
  Widget build(BuildContext context) {

    cf.Size.init(context);
    return
      SafeArea(child: Scaffold(
                appBar: AppBar(
                  title: Text('Tarot Card', style: TextStyle(
                      color: Colors.white,
                      fontSize: cf.Size.blockSizeHorizontal * 4,
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
                //appBar : buildBar(context),
                body:
    SafeArea(child:
                Container(
    width : cf.Size.screenWidth,
    height: cf.Size.screenHeight,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                        children: [

                        Container(
                        height: 50,
                        color: Colors.black12,
                        child:ListView.builder(
                    scrollDirection: Axis.horizontal,

                    physics: ScrollPhysics(),
                    itemCount: 22,
                    itemBuilder: (context, index) {
                      return
                        GestureDetector(
                          child:

                          //  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 8),

                            child:
                            Center(
                              child: Text(
                                  prob_areas[index], style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,
                                /*// primary: (astro_call_status_astro=="1")?Colors.green:(astro_call_status_astro=="0")?Colors.black:Colors.red,

                            color: (is_selected == true)?Colors.red:(is_selected == false)?const Color (0xff212F3D):const Color (0xff212F3D)*/
                                  color: selectedIndex == index
                                      ? Colors.red
                                      : const Color (0xff212F3D))),
                            ),
                          ),
                          //)),
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            selected_category = prob_areas[index].toString();
                            print(prob_areas[index].toString());
                            if (selected_category == "All") {
                              fetchUser();
                            }
                            else {
                              getcategorywiselist();
                            }
                          },

                        );


                      /* children: prob_areas.map((country){
              return box(country, Colors.black12);
              }).toList(),*/
                    }

                )
            ),

            /*Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [*/

            Padding(
            padding: const EdgeInsets.all(10), child:TextField(

            onChanged: (value) => _runFilter(value),
            //_runFilter(value),
            decoration: const InputDecoration(
            labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),),

            /*   Center(
          child: isLoading
              ? const CircularProgressIndicator()
              :*/
            Flexible(
            child: //
            searchlist.isNotEmpty

            ?


            /* if( astrologerslist.contains(null) || astrologerslist.length < 0 || isLoading)
                   {
                     return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black ),));
                   }
                 return*/

            RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                  fetchUser();
                },
                child:
            ListView.separated(
            // scrollDirection: ,
            /* gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 220
                      //childAspectRatio: 2
                    ),
*/
            itemCount: searchlist.length,
            separatorBuilder: (BuildContext context, int index) => Divider(height: 3),

            itemBuilder: (context,index){

            if(searchlist!=null && searchlist.length!=0)
            {
            // return getCard(astrologerslist[index]);
            String agent_id = searchlist[index].ID;
            //selectedagent_id = searchlist[index].ID;
            var fullName = searchlist[index].agentname;
            var email = searchlist[index].title;
            String fcmtoken = searchlist[index].token;
            var profileUrl = searchlist[index].image;
            if(profileUrl!=null)
            {

            profileUrl = searchlist[index].image;
            }
            else
            {
            profileUrl = '${profileUrl}';
            }
            var price = searchlist[index].b_rate;
            var astro_call_status_tarot = searchlist[index].PhoneCallStatus;
            var astro_chat_status_tarot = searchlist[index].ChatStatus;
            astro_mobile = searchlist[index].mob;
            astro_extension = searchlist[index].extension;
            String follow_param = searchlist[index].follow;

            String avg_rating = searchlist[index].avg_rating;
            if(searchlist[index].avg_rating == null)
            {
            double_rating = 0.0;
            }
            else{
            double_rating = double.parse(searchlist[index].avg_rating);
            }


            return
            GestureDetector(

            onTap: () {
            Navigator.push(context,
            MaterialPageRoute(
            builder: (context) {
            return AstroDescription(agent_id: agent_id, agent_follow : follow_param) ;
            },
            ));
            },
            child:
            Container(

            // margin: EdgeInsets.symmetric(vertical: 15 , horizontal: 5),

            /* decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1.0,
                                color: const Color(0xffe22525),
                              )
                          ),*/

            child:Row(
            children: <Widget>[
            Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            shape: BoxShape.rectangle,
            // color: Colors.grey, // inner circle color
            ),

            height: 100.0,
            width: 90.0,
            child:
            ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child:
            CachedNetworkImage
            (
            fit: BoxFit.cover ,
            imageUrl : "https://astroashram.com/uploads/agent/"+profileUrl,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Image.asset('assets/images/profile.png'),
            ),
            )
            ),

                Flexible(child:
            Container(
            height: 100,
            child: Padding(
            padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
            child: Column(
              children: [
                Flexible(child:Container(
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text(fullName,textAlign: TextAlign.center, maxLines : 2,style: TextStyle(
                fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 3.5,fontWeight: FontWeight.w600,color: const Color(0xFF212F3D)
                ),),
                Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                width: 60,
                decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Text('Rs. '+price+' /min',textAlign: TextAlign.center, style: TextStyle(
                fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 1.8 ,color: const Color(0xFF212F3D)
                ),),
                ),
                ),
                Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Container(
                width:260,
                //  alignment: Alignment.center,
                child: RatingBar.builder(
                itemSize: 12,
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
                //print(astro_rating);

                },
                ),
                ),
                ),


                Flexible(child:
                Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly,
                children: [
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                fixedSize: Size( 70,4),
                primary: (astro_call_status_tarot=="1")?Colors.green:(astro_call_status_tarot=="0")?Colors.black:Colors.red,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),

                onPressed: () {


                  if (astro_call_status_tarot ==
                      "1") {


                    if (wallet_balance !=
                        '0') {


                      print(wallet_balance);
                      print(price.toString());

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
                        fontSize: cf.Size.blockSizeHorizontal * 3.5 ,
                      );
                    }
                  }
                else if(astro_call_status_tarot == "0")
                {

                Fluttertoast.showToast(
                msg: "Agent is unavailable, please try after sometime",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                  fontSize: cf.Size.blockSizeHorizontal * 3.5 ,
                );
                }

                else {

                Fluttertoast.showToast(
                msg: "Agent is busy, please try after sometime",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                  fontSize: cf.Size.blockSizeHorizontal * 3.5 ,
                );

                }


                },
                child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly,
                children: [
                Icon( // <-- Icon
                Icons.call,
                size: 10.0,
                ),
                SizedBox(
                width: 2,
                ),
                Text('Call',textAlign: TextAlign.center, style: TextStyle(
                fontFamily: 'Poppins',fontSize:  cf.Size.blockSizeHorizontal * 2.3,color: Colors.white
                ),), // <-- Text

                ],
                ),
                ),
                SizedBox(
                width: 8,
                ),

                ElevatedButton(
                style: ElevatedButton.styleFrom(
                fixedSize: Size( 70,4),
                primary : (astro_chat_status_tarot=="1")?Colors.green:(astro_chat_status_tarot=="0")?Colors.black:Colors.red,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                 /* Fluttertoast.showToast(
                      msg: "Pressed",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
*/
                if (astro_chat_status_tarot ==
                    "1") {


                  if (wallet_balance !=
                      '0') {


                    print(wallet_balance);
                    print(price.toString());

                    double tocalculate = double.parse(wallet_balance)/double.parse(price);

                    int final_rate = tocalculate.floor();
                  /*  Fluttertoast.showToast(
                        msg: final_rate.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );*/
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

                     /* Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserChatWebview(chat_agent_id: agent_id,chat_fcm_token:fcmtoken) ;
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
                      fontSize: cf.Size.blockSizeHorizontal * 3.5 ,
                    );
                  }
                }
                else if(astro_chat_status_tarot == "0")
                {

                Fluttertoast.showToast(
                msg: "Agent is unavailable, please try after sometime",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                  fontSize: cf.Size.blockSizeHorizontal * 3.5 ,
                );
                }

                else {

                Fluttertoast.showToast(
                msg: "Agent is busy, please try after sometime",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                  fontSize: cf.Size.blockSizeHorizontal * 3.5 ,
                );

                }


                },
                child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Icon( // <-- Icon
                Icons.message,
                size: 10.0,
                ),
                SizedBox(
                width: 2,
                ),
                Text('Chat',textAlign: TextAlign.center, style: TextStyle(
                fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.3,color: Colors.white
                ),), // <-- Text

                ],
                ),
                ),

                SizedBox(
                width: 8,
                ),

                Visibility(
                visible: follow_param == "no",
                child:
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                fixedSize: Size( 60,4),
                primary : Colors.white,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),side: BorderSide(width: 1.0, color: Colors.red,),)),
                onPressed: () {


                //  followbuttontext = "Following";


                sendfollow(agent_id);


                },
                child: Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                /* Icon( // <-- Icon
                                                                  Icons.add,
                                                                  size: 10.0,
                                                                  color: const Color(0xff212F3D),
                                                                  //textDirection: Alignment.center,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),*/


                Flexible(child:Container(
                  child: Text(followbuttontext,
                  textAlign: TextAlign.center, style: TextStyle(
                  fontFamily: 'Poppins',fontSize:  cf.Size.blockSizeHorizontal * 2.1, color: const Color(0xff212F3D),
                  ),),
                ),), // <-- Text

                ],
                ),
                ),
                ),


                Visibility(
                visible: follow_param == "yes",
                child:
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                fixedSize: Size(75,4),
                primary : Colors.white,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),side: BorderSide(width: 1.0, color: Colors.red,),)),
                onPressed: () {


                //unfollowbuttontext = "Follow";

                sendfollow(agent_id);


                },
                child: Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                /* Icon( // <-- Icon
                                                                  Icons.add,
                                                                  size: 10.0,
                                                                  color: const Color(0xff212F3D),
                                                                  //textDirection: Alignment.center,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),*/


                Flexible(child:Container(
                  child: Text(unfollowbuttontext,
                  textAlign: TextAlign.center, style: TextStyle(
                  fontFamily: 'Poppins',fontSize:  cf.Size.blockSizeHorizontal * 1.8, color: const Color(0xff212F3D),
                  ),),
                ),), // <-- Text

                ],
                ),
                ),
                ),

                ],
                ),
                ),
                ),


                //  Expanded(child:
                ],
                ),
                )
                ),
              ],
            ),
            ),
            )
                )
            ],

            )));
            }
            })

            )

                : Center(child: new CircularProgressIndicator()),
            /*const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),*/
            ),
            // )
            ],
            )
            ),

            //  getBody(),
            ),
    )
      );

  }

  /* Widget buildBar(BuildContext context) {
    return AppBar(

        title: appBarTitle,
        iconTheme: IconThemeData(color: Colors.orange),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = TextField(
                    controller: _searchQuery,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        hintText: "Search here..",
                        hintStyle: TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }*/

  /* void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }
*/
  /* void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        "Astrologers",
        style: TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }*/



}