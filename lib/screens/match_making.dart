
import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class MatchMakingPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _MatchMakingPageState createState() => _MatchMakingPageState();
}

class _MatchMakingPageState extends State<MatchMakingPage> {

  String boy_name, boy_birthdate, boy_birthtime, boy_birthplace,
      girl_name, girl_birthdate, girl_birthtime, girl_birthplace;
  String boy_place_lat, boy_place_long;
  String girl_place_lat, girl_place_long;
  String   res_male_birth_year ='' ,  res_male_birth_month = '' ,  res_male_birth_day = '' , res_male_birth_minute = '' ,
      res_male_sunrise = '' , res_male_sunset = '' , res_male_ayanamsha = '' , res_male_birth_hour = '' , res_female_birth_year = '',  res_female_birth_month = '',
   res_female_birth_day = '' ,  res_female_birth_minute = '',  res_female_sunrise ='',  res_female_sunset  = '',  res_female_ayanamsha = '' ,
  res_female_birth_hour ='';

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool visibilityparam = false;


  TextEditingController boybirthplaceController = TextEditingController();

  TextEditingController girlbirthplaceController = TextEditingController();

  String boy_birth_year,boy_birth_month,boy_birth_day,boy_birth_hour,boy_birth_minute,boy_birth_location;
  String girl_birth_year,girl_birth_month,girl_birth_day,girl_birth_hour,girl_birth_minute,girl_birth_location;

  var yearlist =  ['Select Year', '1950','1951','1952','1953','1954','1955','1956','1957','1958','1959','1960',
    '1961','1962','1963','1964','1965','1966','1967','1968','1969','1970',
    '1971','1972','1973','1974','1975','1976','1977','1978','1979','1980',
    '1981','1982','1983','1984','1985','1986','1987','1988','1989','1990',
    '1991','1992','1993','1994','1995','1996','1997','1998','1999','2000',
    '2001','2002','2003','2004','2005','2006','2007','2008','2009','2010',
    '2011','2012','2013','2014','2015','2016','2017','2018','2019','2020',
    '2021','2022','2023'
  ];

  var monthlist = ['Select Month','01','02','03','04','05','06','07','08','09','10','11','12'];

  var daylist = ['Select Day','01','02','03','04','05','06','07','08','09','10',
    '11','12','13','14','15','16','17','18','19','20',
    '21','22','23','24','25','26','27','28','29','30','31'];

  var hourlist = ['Select Hour','01','02','03','04','05','06','07','08','09','10',
    '11','12','13','14','15','16','17','18','19','20',
    '21','22','23','24'];

  var minutelist = ['Select Minutes','01','02','03','04','05','06','07','08','09','10',
    '11','12','13','14','15','16','17','18','19','20',
    '21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38',
    '39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55',
    '56','57','58','59','60'];

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetch_about_us(context);
  }*/

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
      child:
      Scaffold(
          resizeToAvoidBottomInset:false,
          appBar: AppBar(
            title: Text('Match Making ', style: TextStyle(
                color: Colors.white,
                fontSize:  cf.Size.blockSizeHorizontal * 4, fontFamily: 'Poppins',
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

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  /** Card Widget **/
                  child: Card(
                    elevation: 30,
                    shadowColor: Colors.black,
                   // color: Colors.,
                    child: SizedBox(
                      width: double.infinity,
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                        Center(
                          child: Text(
                            'Boys Details',
                            style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 4, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ), //Textstyle
                          ),
                        ), //Text
                        SizedBox(
                          height: 10,
                        ), //SizedBox

                            Text("Select Year *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(

                              isExpanded: true,
                              value: boy_birth_year,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:yearlist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  boy_birth_year = newValue.toString();
                                });
                              },

                            ),

                            SizedBox(height: 20.0,),

                            Text("Select Month *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: boy_birth_month,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:monthlist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  boy_birth_month = newValue.toString();
                                });
                              },

                            ),


                            SizedBox(height: 20.0,),

                            Text("Select Day *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: boy_birth_day,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:daylist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  boy_birth_day = newValue.toString();
                                });
                              },

                            ),

                            SizedBox(height: 20.0,),


                            Text("Select Hour *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: boy_birth_hour,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:hourlist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  boy_birth_hour = newValue.toString();
                                });
                              },

                            ),

                            SizedBox(height: 20.0,),

                            Text("Select Minute *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: boy_birth_minute,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:minutelist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  boy_birth_minute = newValue.toString();
                                });
                              },

                            ),


                            SizedBox(height: 10.0,),

                            TextFormField(
                              autofocus: false,
                              style: TextStyle(
                                fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                color: Colors.green[900],
                                fontWeight: FontWeight.w500,
                              ),
                              onSaved: (value) => boy_birth_location = value,
                              onTap: ()
                              {

                                showGooglePlaceWidget1();

                              },
                              validator: (val) =>
                              val.isEmpty ? 'Enter birth place' : null,
                              onChanged: (val) async {
                                setState(() => boy_birth_location = val);

                              },
                              decoration: buildInputDecoration(
                                  "Enter birth place", Icons.location_on),
                              controller: boybirthplaceController,
                            ),


                          ],
                    ), //Column
                  ), //Padding
                ), //SizedBox
        ), //Card
      ),

                SizedBox(height: 20),
                Center(
                  /** Card Widget **/
                  child: Card(
                    elevation: 30,
                    shadowColor: Colors.black,
                   // color: Colors.greenAccent[100],
                    child: SizedBox(
                      width: double.infinity,
                      height: 700,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Center(
                              child: Text(
                                'Girls Details',style: TextStyle(
                                fontSize: cf.Size.blockSizeHorizontal * 4.5, fontFamily: 'Poppins',
                                color: Colors.green[900],
                                fontWeight: FontWeight.w500,
                              ),
                               //Textstyle
                              ),
                            ), //Text
                            SizedBox(
                              height: 10,
                            ), //SizedBox


                            Text("Select Year *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(

                              isExpanded: true,
                              value: girl_birth_year,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:yearlist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  girl_birth_year = newValue.toString();
                                });
                              },

                            ),

                            SizedBox(height: 20.0,),

                            Text("Select Month *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: girl_birth_month,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:monthlist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  girl_birth_month = newValue.toString();
                                });
                              },

                            ),


                            SizedBox(height: 20.0,),

                            Text("Select Day *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: girl_birth_day,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:daylist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  girl_birth_day = newValue.toString();
                                });
                              },

                            ),

                            SizedBox(height: 20.0,),


                            Text("Select Hour *",style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: girl_birth_hour,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:hourlist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal *3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  girl_birth_hour = newValue.toString();
                                });
                              },

                            ),

                            SizedBox(height: 20.0,),

                            Text("Select Minute *",style: TextStyle(
                            fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),),
                            SizedBox(width : 35.0,),

                            DropdownButton(
                              isExpanded: true,
                              value: girl_birth_minute,

                              icon: Icon(Icons.keyboard_arrow_down),

                              items:minutelist.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                      color: Colors.green[900],
                                      fontWeight: FontWeight.w500,
                                    ),)
                                );
                              }
                              ).toList(),
                              onChanged: (newValue){
                                setState(() {

                                  girl_birth_minute = newValue.toString();
                                });
                              },

                            ),


                            SizedBox(height: 10.0,),

                            TextFormField(
                              autofocus: false,
                              style: TextStyle(
                                fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                color: Colors.green[900],
                                fontWeight: FontWeight.w500,
                              ),
                              onSaved: (value) => girl_birth_location = value,
                              onTap: ()
                              {

                                showGooglePlaceWidget2();

                              },
                              validator: (val) =>
                              val.isEmpty ? 'Enter birth place' : null,
                              onChanged: (val) async {
                                setState(() => girl_birth_location = val);

                              },
                              decoration: buildInputDecoration(
                                  "Enter birth place", Icons.location_on),
                              controller: girlbirthplaceController,
                            ),

                            SizedBox(height: 20),
                            Container(
                              alignment: Alignment.center,
                              child : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(0xffe22525)),
                                child: Text("Match Horoscope",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3),),
                                onPressed: ()
                                {

                                  send_match_making();

                                  // Navigator.pushReplacementNamed(context, '/login');
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);


                                },
                              ),
                            ),

                            /*GestureDetector(
                              onTap: () {
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
                                child: Text("Match Horoscope", style: TextStyle(
                                  fontSize: cf.Size.blockSizeHorizontal * 3, fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ),
                            ),*/
                          ],
                        ), //Column
                      ), //Padding
                    ), //SizedBox
                  ), //Card
                ),


                addcardwidget()
                /*Visibility(
                    visible: visibilityparam,
                    child:addcardwidget()
                ),
*/

              ],
            ),
          ), //Center


        ),




      ),
    );

  }

  Widget addcardwidget()
  {
    return

      Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Male Astro Details',textAlign: TextAlign.left,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')),

            Container(
                decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      width: 1.0,
                      color: const Color(0xffe22525),
                    )
                ),
                child:

                Column( crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(15),
                        child: Table(
                          //  defaultColumnWidth: FixedColumnWidth(120.0),
                          /* border: TableBorder.all(
                                               color: Colors.black,
                                               style: BorderStyle.solid,
                                               width: 2),*/
                          children: [
                            /* TableRow( children: [
                                    Column(children:[Text('Name',textAlign: TextAlign.left)]),
                                    Column(children:[Text(bir)]),
                                  ]),*/
                            TableRow( children: [
                              Column( crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('Birth Date',textAlign: TextAlign.left,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_male_birth_day}'+'-'+'${res_male_birth_month}'+'-'+'${res_male_birth_year}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                            ]),
                            TableRow( children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('Hour',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_male_birth_hour}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                            ]),
                            TableRow( children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('Minutes',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_male_birth_minute}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                            ]),
                            TableRow( children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunrise',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_male_sunrise}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                            ]),
                            TableRow( children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunset',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_male_sunset}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                            ]),
                            TableRow( children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('Ayanamsha',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_male_ayanamsha}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                            ]),

                          ],
                        ),
                      ),
                    ])
            ),

            SizedBox(height: 20),
            Text('Female Astro Details',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')),

            Container(
                decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      width: 1.0,
                      color: const Color(0xffe22525),
                    )
                ),
                child:

                Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Table(
                      //defaultColumnWidth: FixedColumnWidth(120.0),
                      /* border: TableBorder.all(
                                               color: Colors.black,
                                               style: BorderStyle.solid,
                                               width: 2),*/
                      children: [
                        /* TableRow( children: [
                                    Column(children:[Text('Name',textAlign: TextAlign.left)]),
                                    Column(children:[Text(bir)]),
                                  ]),*/
                        TableRow( children: [
                          Column( crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Birth Date',textAlign: TextAlign.left,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_female_birth_day}'+'-'+'${res_female_birth_month}'+'-'+'${res_female_birth_year}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Hour',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_female_birth_hour}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Minutes',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_female_birth_minute}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunrise',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_female_sunrise}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunset',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_female_sunset}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Ayanamsha',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${res_female_ayanamsha}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),


                      ],
                    ),
                  ),
                ])
            ),


          ],
        ),
      );

  }

  Future showGooglePlaceWidget1() async {
    // Prediction p = await PlacesAutocomplete.show(
    var place = await PlacesAutocomplete.show(

        context: context,
        apiKey: "AIzaSyC54_RnAsutpoao87j9w-OmbawLMdKA1jo",
        mode: Mode.overlay,
        language: "en",
        radius: 10000000 == null ? null : 10000000

    );

    setState(() {
      boy_birth_location = place.description.toString();
      boybirthplaceController.text = boy_birth_location;
      get_boylatlong(boy_birth_location);

    });

  }

  Future showGooglePlaceWidget2() async {
    // Prediction p = await PlacesAutocomplete.show(
    var place = await PlacesAutocomplete.show(

        context: context,
        apiKey: "AIzaSyC54_RnAsutpoao87j9w-OmbawLMdKA1jo",
        mode: Mode.overlay,
        language: "en",
        radius: 10000000 == null ? null : 10000000

    );

    setState(() {
      girl_birth_location = place.description.toString();
      girlbirthplaceController.text = girl_birth_location;
      get_girllatlong(girl_birth_location);

    });

  }

  void get_boylatlong(String birth_location) async {
    final query = birth_location;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    String coordinates = first.coordinates.toString();
    print('coordinates' + coordinates);
    List<String> result = coordinates.split(',');
    boy_place_lat = result[0];
    List<String> result_lat = boy_place_lat.split('{');
    //place_lat.replaceAll('{', '');
    print('place_lat' + result_lat[1]);
    boy_place_lat = result_lat[1];
    boy_place_long = result[1];
    List<String> result_long = boy_place_long.split('}');
    //  place_long.replaceAll('}', '');
    print('place_long' + result_long[0]);
    boy_place_long = result_long[0];
  }
  void get_girllatlong(String birth_location) async {
    final query = birth_location;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    String coordinates = first.coordinates.toString();
    print('coordinates' + coordinates);
    List<String> result = coordinates.split(',');
    girl_place_lat = result[0];
    List<String> result_lat = girl_place_lat.split('{');
    //place_lat.replaceAll('{', '');
    print('place_lat' + result_lat[1]);
    girl_place_lat = result_lat[1];
    girl_place_long = result[1];
    List<String> result_long = girl_place_long.split('}');
    //  place_long.replaceAll('}', '');
    print('place_long' + result_long[0]);
    girl_place_long = result_long[0];
  }


  void send_match_making() async {

    DateTime now = DateTime.now();
    //  var timezone = now.timeZoneName;
    var toffset = now.timeZoneOffset;

    final url = Uri.parse('https://json.astrologyapi.com/v1/match_birth_details');
    final headers = {"authorization": "Basic " + base64.encode(utf8.encode("619558:fad80d4883db59a54e377aa96f515e72")),"Content-type": "application/json"};

    final json = jsonEncode({"m_day":boy_birth_day,
      "m_month":boy_birth_month,
      "m_year":boy_birth_year,
      "m_hour":boy_birth_hour,
      "m_min":boy_birth_minute,
      "m_lat":boy_place_lat,
      "m_lon":boy_place_long,
      "m_tzone":toffset.toString(),

      "f_day":girl_birth_day,
      "f_month":girl_birth_month,
      "f_year":girl_birth_year,
      "f_hour":girl_birth_hour,
      "f_min":girl_birth_minute,
      "f_lat":girl_place_lat,
      "f_lon":girl_place_long,
      "f_tzone":toffset.toString(),

    });


   // print(place_lat);

    final response = await post(url, headers: headers, body: json);
    // main_list = await api.getbirthdetails(requestModel);

    var matchmaking_response = jsonDecode(response.body.toString());
    //print(matchmaking_response['male_astro_details']['year']);

    setState(() {
      visibilityparam = true;

    });

    res_male_birth_year = (matchmaking_response['male_astro_details']['year']).toString();
    res_male_birth_month = (matchmaking_response['male_astro_details']['month']).toString();
    res_male_birth_day = (matchmaking_response['male_astro_details']['day']).toString();
    res_male_birth_minute = (matchmaking_response['male_astro_details']['minute']).toString();
    res_male_sunrise = (matchmaking_response['male_astro_details']['sunrise']).toString();
    res_male_sunset = (matchmaking_response['male_astro_details']['sunset']).toString();
    res_male_ayanamsha = (matchmaking_response['male_astro_details']['ayanamsha']).toString();
    res_male_birth_hour = (matchmaking_response['male_astro_details']['hour']).toString();

    res_female_birth_year = (matchmaking_response['female_astro_details']['year']).toString();
    res_female_birth_month = (matchmaking_response['female_astro_details']['month']).toString();
    res_female_birth_day = (matchmaking_response['female_astro_details']['day']).toString();
    res_female_birth_minute = (matchmaking_response['female_astro_details']['minute']).toString();
    res_female_sunrise = (matchmaking_response['female_astro_details']['sunrise']).toString();
    res_female_sunset = (matchmaking_response['female_astro_details']['sunset']).toString();
    res_female_ayanamsha = (matchmaking_response['female_astro_details']['ayanamsha']).toString();
    res_female_birth_hour = (matchmaking_response['female_astro_details']['hour']).toString();


    // print(response.body);

  }




}
