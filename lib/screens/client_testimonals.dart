import 'dart:async';
import 'dart:convert';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:internet_connection_checker/internet_connection_checker.dart';


class TestimonalPage extends StatefulWidget {
  @override
  _TestimonalPageState createState() => _TestimonalPageState();
}

class _TestimonalPageState extends State<TestimonalPage> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  List testimonallist = [];
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    this.fetch_testimonals();
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

  fetch_testimonals() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(AppUrl.testimonal_data);
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      setState(() {
        testimonallist = items;
        isLoading = false;
      });
    }else{
      testimonallist = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Testimonals', style: TextStyle(
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
      body: getBody(),
    );
  }
  Widget getBody(){
    if(testimonallist.contains(null) || testimonallist.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black ),));
    }


    return ListView.builder(

        itemCount: testimonallist.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return getCard(testimonallist[index]);
        });
  }


  Widget getCard(item){
    var fullName = item['title'];
    var email = item['description'];
    var profileUrl = item['image'];
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Column(
            children: <Widget>[

              SizedBox(width: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(60/2),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('https://astroashram.com/uploads/testimonial/'+profileUrl)
                        )
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      height:MediaQuery.of(context).size.height/12,
                      child:
                          Center(
                            child:
                      Text(
                          fullName,style: TextStyle(fontSize:  cf.Size.blockSizeHorizontal * 4.3,color :const Color(0xffe22525), fontFamily: 'Poppins',fontWeight:FontWeight.w500),textAlign: TextAlign.center)),),
                  SizedBox(height: 10,),

                ],
              ),

              Container(
                child:
                    Html(data:email,defaultTextStyle: TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
               // Text(email.toString(),style: TextStyle(color: const Color(0xffe22525),fontFamily: 'Poppins'),textAlign: TextAlign.justify),
              ),

            ],


          ),
        ),
      ),
    );
  }
}