
import 'dart:async';

import 'package:ascology_app/screens/user_profile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class BlogDescription extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  String blog_id;

  BlogDescription({this.blog_id});

  @override
  _BlogDescriptionState createState() => _BlogDescriptionState();
}

class _BlogDescriptionState extends State<BlogDescription> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = false;
  String got_blog_id;
  List bloglist = [];

  PageController _pageController;

  String astro_services, astro_timing, astro_experience, astro_extension,
      astro_language, astro_img, astro_shortdesc,
      astro_agentname, astro_mobile;
  var astro_about;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getConnectivity();
    got_blog_id = widget.blog_id;
    print(got_blog_id);

    //fetch_agent_details();


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

  @override
  Widget build(BuildContext context) {
    const rowSpacer = TableRow(
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Blogs', style: TextStyle(
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


          actions: [

            PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("My Profile", style: TextStyle(
                          fontFamily: 'Poppins'
                        //  fontSize: 36.0,
                      ),),
                    ),



                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("Logout", style: TextStyle(
                          fontFamily: 'Poppins'),
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    print("My account menu is selected.");
                    Navigator.pushReplacement(
                        context, new MaterialPageRoute(builder:
                        (context) => UserProfile()));
                  }
                else if (value == 1) {
                    print("Logout menu is selected.");
                  }
                }
            ),


          ],),

        body: SingleChildScrollView(
          child:

          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            //  height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.
            //width: MediaQuery.of(context).size.width,
            child:
            //  padding: EdgeInsets.all(20),
            /*Flex( direction: Axis.vertical,
              children: [
              Expanded(*/
            Flexible(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(60 / 2),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://astroashram.com/uploads/agent/' +
                                          astro_img)
                                //daee640aaf2738bec6203e1c22e22412.jpg')
                              )
                          ),
                        ),

                        /* Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                     alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
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
                      children: <Widget>[

                        Container(
                          width: 300,
                          height: 50,
                          alignment: Alignment.center,

                          child: Text(astro_agentname.toString(),
                            textAlign: TextAlign.justify, style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,


                            ),),
                        ),
                      ]
                  ),


                  Container(
                    width: 300,
                    child: Center(
                        child: Column(children: <Widget>[
                          /* Container(
                        margin: EdgeInsets.all(10),*/
                          Padding(
                            padding: const EdgeInsets.all(12.0),

                            child: Table(
                              // border: TableBorder.all(),
                              children: [
                                TableRow(children: [

                                  Text('Service'),


                                  Text(':', textAlign: TextAlign.center),

                                  Text(astro_services.toString()),

                                ]),

                                rowSpacer,
                                TableRow(children: [

                                  Text('Experience'),

                                  Text(':', textAlign: TextAlign.center),

                                  Text(astro_experience.toString()),

                                ]),
                                rowSpacer,
                                TableRow(children: [

                                  Text('Expertise'),

                                  Text(':', textAlign: TextAlign.center),

                                  Text(astro_shortdesc.toString()),

                                ]),
                                rowSpacer,
                                TableRow(children: [

                                  Text('Availability'),

                                  Text(':', textAlign: TextAlign.center),

                                  Text(astro_timing.toString()),

                                ]),
                                rowSpacer,
                                TableRow(children: [

                                  Text('Extension'),

                                  Text(':', textAlign: TextAlign.center),

                                  Text(astro_extension.toString()),

                                ]),
                                rowSpacer,
                              ],
                            ),
                          ),
                          // ),
                        ])
                    ),
                  ),
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
                            color: const Color(0xffe22525),
                            /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),*/
                            onPressed: () {

                            },
                          ),
                          Text('Chat', textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: 'Poppins'))
                        ],),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            // minWidth: 25.0,
                            iconSize: 30,
                            color: const Color(0xffe22525),
                            icon: Icon(Icons.call),
                            /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),*/
                            onPressed: () {
                              //  call_astrologer();
                              //        https://asccology.com/call_api/callapi.php?extension=$mobile_num&code=$extension&submit=call

                            },
                          ),
                          Text('Call', textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: 'Poppins'))
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

                            },
                          ),
                          Text('Video Call', textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: 'Poppins'))
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
                      children: <Widget>[
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child:
                            Column(

                              children: <Widget>[
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 30,
                                  margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                  //  alignment: Alignment.center,

                                  child: Text("Profile Summary",
                                    textAlign: TextAlign.left, style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,

                                    ),),
                                ),

                                Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height / 4,
                                    margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                                    //  alignment: Alignment.center,

                                    // child: Text(Html(data:astro_about),textAlign: TextAlign.left, style: TextStyle(
                                    child: Html(data: astro_about)),


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
            ),
          ),


        ),


      ),
    );


    // print('data:'+astrologerDetails.)


  }


/* void fetch_agent_details() async {
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
    if (userModel.status = true) {
      print(userModel.data);

      astro_services = userModel.data[0].title.toString();
      astro_timing = userModel.data[0].timing.toString();
      astro_experience = userModel.data[0].experience.toString();
      astro_extension = userModel.data[0].extension.toString();
      astro_language = userModel.data[0].id_language.toString();
      astro_img = userModel.data[0].image;
      astro_about = userModel.data[0].about.toString();
      astro_shortdesc = userModel.data[0].short_description.toString();
      astro_agentname = userModel.data[0].agentname.toString();
      astro_mobile = userModel.data[0].mob.toString();



      //  String a = AstrologerDetails.fromJson(userModel.data).agentname;


      */ /*  AstrologerDetails details = AstrologerDetails();
          details.agentname = userModel.data.asMap()
*/ /*
    }
    else {
      print(userModel.message);
    }
  }*/
}
