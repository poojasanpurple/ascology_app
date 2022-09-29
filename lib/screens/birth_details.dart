import 'dart:async';
import 'dart:io';
import 'dart:convert';


import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/birthdetails_request.dart';
import 'package:ascology_app/model/request/user_register_request.dart';
import 'package:ascology_app/model/response/astro_details_output.dart';
import 'package:ascology_app/model/response/auspicious_output.dart';
import 'package:ascology_app/model/response/basic_panchang_output.dart';
import 'package:ascology_app/model/response/birth_details_output.dart';
import 'package:ascology_app/model/response/birth_details_response.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/login.dart';
import 'package:ascology_app/screens/user_verify_otp.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:math';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class BirthDetails extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  @override
  _BirthDetailsState createState() => _BirthDetailsState();
}

class _BirthDetailsState extends State<BirthDetails> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  // static const kGoogleApiKey = "AIzaSyC54_RnAsutpoao87j9w-OmbawLMdKA1jo";
  //GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  bool visibilityparam = false;

  List<BirthDetailsResponse> main_list = List();
  List<BirthDetailsOutput> birth_list = List();
  List<AstroDetailsOutput> astro_list = List();
  List<AuspiciousMuhurtaOutput> auspicious_list = List();
  List<BasicPanchangOutput> panchang_list = List();
  String astro_ascendant = '' , astro_varna = '' , astro_vashya ='',  astro_yoni='',
  astro_gan='',   astro_nadi='' ,  astro_signlord='' ,  astro_sign='' ,  astro_nakshatra='' ,
    astro_nakshatralord='' ,  astro_charan='' ,  astro_yog='' ,  astro_karan='' ,  astro_tithi='' ,
  astro_yunja='' ,  astro_tatva='' ,  astro_name_alp='' ,  astro_paya='' ;
  bool isLoading = false;
  String address = '';
  String place_lat, place_long, response_birth_year='',response_birth_month='',response_birth_day='',response_birth_hour='',
      response_birth_minute='',response_sunrise='',response_sunset='',response_ayanamsha='';
  List<Widget> _cardList = [];


  String  panchang_day='' , panchang_tithi='', panchang_yog='', panchang_nakshatra='',  panchang_karan='' ,
  panchang_sunrise='',  panchang_sunset='' ;
  var yearlist = [
    'Select Year',
    '1950',
    '1951',
    '1952',
    '1953',
    '1954',
    '1955',
    '1956',
    '1957',
    '1958',
    '1959',
    '1960',
    '1961',
    '1962',
    '1963',
    '1964',
    '1965',
    '1966',
    '1967',
    '1968',
    '1969',
    '1970',
    '1971',
    '1972',
    '1973',
    '1974',
    '1975',
    '1976',
    '1977',
    '1978',
    '1979',
    '1980',
    '1981',
    '1982',
    '1983',
    '1984',
    '1985',
    '1986',
    '1987',
    '1988',
    '1989',
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023'
  ];

  var monthlist = [
    'Select Month',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];

  var daylist = [
    'Select Day',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];

  var hourlist = [
    'Select Hour',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];

  var minutelist = [
    'Select Minutes',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60'
  ];


  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String apkversion = '1.0';
  String birth_year, birth_month, birth_day, birth_hour, birth_minute,
      birth_location;

  /*TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();*/
  TextEditingController locationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2024));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

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
  void _addCardWidget() {
    setState(() {
      _cardList.add(addcardwidget());
    });
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
          appBar: AppBar(
            title: Text('Birth Details', style: TextStyle(
                color: Colors.white,
              fontSize: cf.Size.blockSizeHorizontal * 4
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    SizedBox(height: 15.0,),

                    Text("Select Year *",style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins')),
                    SizedBox(width: 35.0,),

                    DropdownButton(

                      isExpanded: true,
                      value: birth_year,

                      icon: Icon(Icons.keyboard_arrow_down),

                      items: yearlist.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins'))
                        );
                      }
                      ).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          birth_year = newValue.toString();
                        });
                      },

                    ),

                    SizedBox(height: 20.0,),

                    Text("Select Month *",style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins')),
                    SizedBox(width: 35.0,),

                    DropdownButton(
                      isExpanded: true,
                      value: birth_month,

                      icon: Icon(Icons.keyboard_arrow_down),

                      items: monthlist.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins'))
                        );
                      }
                      ).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          birth_month = newValue.toString();
                        });
                      },

                    ),


                    SizedBox(height: 20.0,),

                    Text("Select Day *",style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins')),
                    SizedBox(width: 35.0,),

                    DropdownButton(
                      isExpanded: true,
                      value: birth_day,

                      icon: Icon(Icons.keyboard_arrow_down),

                      items: daylist.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins'))
                        );
                      }
                      ).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          birth_day = newValue.toString();
                        });
                      },

                    ),

                    SizedBox(height: 20.0,),


                    Text("Select Hour *",style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins')),
                    SizedBox(width: 35.0,),

                    DropdownButton(
                      isExpanded: true,
                      value: birth_hour,

                      icon: Icon(Icons.keyboard_arrow_down),

                      items: hourlist.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins'))
                        );
                      }
                      ).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          birth_hour = newValue.toString();
                        });
                      },

                    ),

                    SizedBox(height: 20.0,),

                    Text("Select Minute *",style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins')),
                    SizedBox(width: 35.0,),

                    DropdownButton(
                      isExpanded: true,
                      value: birth_minute,

                      icon: Icon(Icons.keyboard_arrow_down),

                      items: minutelist.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins'))
                        );
                      }
                      ).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          birth_minute = newValue.toString();
                        });
                      },

                    ),


                    SizedBox(height: 10.0,),

                    TextFormField(style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3,color: Colors.black,fontFamily: 'Poppins'),
                      autofocus: false,

                      onSaved: (value) => birth_location = value,
                      onTap: () {
                        showGooglePlaceWidget();
// From a query
                      },
                      validator: (val) =>
                      val.isEmpty ? 'Enter birth place' : null,
                      onChanged: (val) async {
                        setState(() => birth_location = val);
                      },
                      decoration: buildInputDecoration(
                          "Enter birth place", Icons.location_on),
                      controller: locationController,
                    ),


                    Container(
                      alignment: Alignment.center,
                      child : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xffe22525)),
                        child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3),),
                        onPressed: ()
                        {


                          send_birth_details();

                          send_astro_details();

                          send_basicpanchang_details();



                          setState(() {
                            visibilityparam = true;
                          });
                          // Navigator.pushReplacementNamed(context, '/login');
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);


                        },
                      ),
                    ),
                    addcardwidget()

                /*Visibility(
                    visible: visibilityparam,
                    child:addcardwidget()
                ),*/

                   /* GestureDetector(
                      onTap: () {





                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.fromLTRB(
                            50.0, 30, 50.0, 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: const Color(0xffe22525)),
                          borderRadius: const BorderRadius.all(Radius.circular(
                              40)),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/getnow.png'),
                              fit: BoxFit.cover
                          ),
                        ),
                        // button text
                        child: Text("Submit", style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: cf.Size.blockSizeHorizontal * 3,
                            color: Colors.white


                        ),),
                      ),
                    ),*/


                  ],
                ),
              ),
            ),


          ),
        )
    );
  }

  Widget addcardwidget()
  {
    return

   Container(
     child: Column(
          children: [
            SizedBox(height: 20),
            Text('Birth Details',textAlign: TextAlign.left,style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')),

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
                    margin: EdgeInsets.all(20),
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
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${response_birth_day}'+'-'+'${response_birth_month}'+'-'+'${response_birth_year}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Hour',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${response_birth_hour}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Minutes',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${response_birth_minute}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunrise',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${response_sunrise}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunset',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${response_sunset}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Ayanamsha',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${response_ayanamsha}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                      ],
                    ),
                  ),
                ])
            ),

            SizedBox(height: 20),
            Text('Astro Details',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')),

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
                    margin: EdgeInsets.all(20),
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
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Ascendant',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_ascendant}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Varna',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_varna}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Vashya',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_vashya}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Yoni',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_yoni}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Gan',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_gan}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Nadi',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_nadi}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('SignLord',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_signlord}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sign',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_sign}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Nakshatra',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_nakshatra}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('NakshatraLord',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_nakshatralord}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Charan',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_charan}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Yog',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_yog}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Karan',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_karan}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Tithi',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_tithi}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Yunja',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_yunja}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Tatva',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_tatva}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Name alphabet',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_name_alp}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),

                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Paya',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${astro_paya}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),


                      ],
                    ),
                  ),
                ])
            ),

            SizedBox(height: 20),

            Text('Basic Panchang',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.black,fontFamily: 'Poppins')),

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
                    margin: EdgeInsets.all(20),
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
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Day',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_day}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Tithi',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_tithi}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Nakshatra',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_nakshatra}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Yog',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_yog}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Karan',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_karan}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunrise',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_sunrise}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunset',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_sunset}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
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
 /* Future<void> birth_detail_request() async {
    final url = Uri.parse('https://json.astrologyapi.com/v1/birth_details');
    final headers = {"authorization": "Basic " + base64.encode(utf8.encode("619558:fad80d4883db59a54e377aa96f515e72")),"Content-type": "application/json"};


    final json = '{"title": "Hello", "body": "body text", "userId": 1}';
    final response = await post(url, headers: headers, body: json);
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
  }
*/
  void send_birth_details() async {

    DateTime now = DateTime.now();
  //  var timezone = now.timeZoneName;
    var toffset = now.timeZoneOffset;

     setState(() {
       isLoading = true;
     });

     final url = Uri.parse('https://json.astrologyapi.com/v1/birth_details');
     final headers = {"authorization": "Basic " + base64.encode(utf8.encode("619558:fad80d4883db59a54e377aa96f515e72")),"Content-type": "application/json"};

    // place_lat = place_lat.replaceAll('{', '');

    // LoginApiClient api = LoginApiClient();
   //  BirthDetailsRequestModel requestModel = new BirthDetailsRequestModel();

    final json = jsonEncode({"year":birth_year,
      "month":birth_month,
      "day":birth_day,
      "hour":birth_hour,
    "min":birth_minute,
    "lat":place_lat,
    "lon":place_long,
    "tzone":toffset.toString()});


     print(place_lat);

     final response = await post(url, headers: headers, body: json);
    // main_list = await api.getbirthdetails(requestModel);
     setState(() {
      // main_list = main_list;
       // searchlist = callhistorylist;
       isLoading = false;
     });

     var birth_response = jsonDecode(response.body.toString());
     print(birth_response);
   /*  response_birth_year = birth_response['year'].toString();
    response_birth_month = birth_response['month'].toString();
    response_birth_day = birth_response['day'].toString();
     response_birth_year = birth_response['year'].toString();
     response_birth_year = birth_response['year'].toString();
     response_birth_year = birth_response['year'].toString();
     response_birth_year = birth_response['year'].toString();*/

    if (response_birth_year != null) {
      response_birth_year = (birth_response['year']).toString();
    }
    else {
      response_birth_year = '';
    }

    if (response_birth_month != null) {
      response_birth_month = (birth_response['month']).toString();
    }
    else {
      response_birth_month = '';
    }


    if (response_birth_day != null) {
      response_birth_day = (birth_response['day']).toString();
    }
    else {
      response_birth_day = '';
    }

    if (response_birth_minute != null) {
      response_birth_minute = (birth_response['minute']).toString();
    }
    else {
      response_birth_minute = '';
    }

    if (response_sunrise != null) {
      response_sunrise = (birth_response['sunrise']).toString();
    }
    else {
      response_sunrise = '';
    }

    if (response_sunset != null) {
      response_sunset = (birth_response['sunset']).toString();
    }
    else {
      response_sunset = '';
    }

    if (response_ayanamsha != null) {
      response_ayanamsha = (birth_response['ayanamsha']).toString();
    }
    else {
      response_ayanamsha = '';
    }

    if (response_birth_hour != null) {
      response_birth_hour = (birth_response['hour']).toString();
    }
    else {
      response_birth_hour = '';
    }

    // print(response.body);

   }

  void send_astro_details() async {

    DateTime now = DateTime.now();
    //  var timezone = now.timeZoneName;
    var toffset = now.timeZoneOffset;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://json.astrologyapi.com/v1/astro_details');
    final headers = {"authorization": "Basic " + base64.encode(utf8.encode("619558:fad80d4883db59a54e377aa96f515e72")),"Content-type": "application/json"};

    // place_lat = place_lat.replaceAll('{', '');

    // LoginApiClient api = LoginApiClient();
    //  BirthDetailsRequestModel requestModel = new BirthDetailsRequestModel();

    final json = jsonEncode({"year":birth_year,
      "month":birth_month,
      "day":birth_day,
      "hour":birth_hour,
      "min":birth_minute,
      "lat":place_lat,
      "lon":place_long,
      "tzone":toffset.toString()});

    print(place_lat);

    final response = await post(url, headers: headers, body: json);
    // main_list = await api.getbirthdetails(requestModel);
    setState(() {
      // main_list = main_list;
      // searchlist = callhistorylist;
      isLoading = false;
    });

    var astro_response = jsonDecode(response.body.toString());
    print(astro_response);


    if (astro_ascendant != null) {
      astro_ascendant = (astro_response['ascendant']).toString();
    }
    else {
      astro_ascendant = '';
    }

    if (astro_varna != null) {
      astro_varna = (astro_response['Varna']).toString();
    }
    else {
      astro_varna = '';
    }

    if (astro_vashya != null) {
      astro_vashya = (astro_response['Vashya']).toString();
    }
    else {
      astro_vashya = '';
    }

    if (astro_yoni != null) {
      astro_yoni = (astro_response['Yoni']).toString();
    }
    else {
      astro_yoni = '';
    }

    if (astro_gan != null) {
      astro_gan = (astro_response['Gan']).toString();
    }
    else {
      astro_gan = '';
    }


    if (astro_nadi != null) {
      astro_nadi = (astro_response['Nadi']).toString();
    }
    else {
      astro_nadi = '';
    }


    if (astro_signlord != null) {
      astro_signlord = (astro_response['SignLord']).toString();
    }
    else {
      astro_signlord = '';
    }

    if (astro_sign != null) {
      astro_sign = (astro_response['sign']).toString();
    }
    else {
      astro_sign = '';
    }

    if (astro_nakshatra != null) {
      astro_nakshatra = (astro_response['Naksahtra']).toString();
    }
    else {
      astro_nakshatra = '';
    }

    if (astro_nakshatralord != null) {
      astro_nakshatralord = (astro_response['NaksahtraLord']).toString();
    }
    else {
      astro_nakshatralord = '';
    }

    if (astro_charan != null) {
      astro_charan = (astro_response['Charan']).toString();
    }
    else {
      astro_charan = '';
    }

    if (astro_yog != null) {
      astro_yog = (astro_response['Yog']).toString();
    }
    else {
      astro_yog = '';
    }

    if (astro_karan != null) {
      astro_karan = (astro_response['Karan']).toString();
    }
    else {
      astro_karan = '';
    }

    if (astro_tithi != null) {
      astro_tithi = (astro_response['Tithi']).toString();
    }
    else {
      astro_tithi = '';
    }

    if (astro_yunja != null) {
      astro_yunja = (astro_response['yunja']).toString();
    }
    else {
      astro_yunja = '';
    }

    if (astro_tatva != null) {
      astro_tatva = (astro_response['tatva']).toString();
    }
    else {
      astro_tatva = '';
    }

    if (astro_name_alp != null) {
      astro_name_alp = (astro_response['name_alphabet']).toString();
    }
    else {
      astro_name_alp = '';
    }

    if (astro_paya != null) {
      astro_paya = (astro_response['paya']).toString();
    }
    else {
      astro_paya = '';
    }


  }

  void send_basicpanchang_details() async {

    DateTime now = DateTime.now();
    //  var timezone = now.timeZoneName;
    var toffset = now.timeZoneOffset;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://json.astrologyapi.com/v1/basic_panchang');
    final headers = {"authorization": "Basic " + base64.encode(utf8.encode("619558:fad80d4883db59a54e377aa96f515e72")),"Content-type": "application/json"};

    // place_lat = place_lat.replaceAll('{', '');

    // LoginApiClient api = LoginApiClient();
    //  BirthDetailsRequestModel requestModel = new BirthDetailsRequestModel();

    final json = jsonEncode({"year":birth_year,
      "month":birth_month,
      "day":birth_day,
      "hour":birth_hour,
      "min":birth_minute,
      "lat":place_lat,
      "lon":place_long,
      "tzone":toffset.toString()});


    print(place_lat);

    final response = await post(url, headers: headers, body: json);
    // main_list = await api.getbirthdetails(requestModel);
    setState(() {
      // main_list = main_list;
      // searchlist = callhistorylist;
      isLoading = false;
    });

    print(response.body);

    var panchang_response = jsonDecode(response.body.toString());
    print(panchang_response);

    if (panchang_day != null) {
      panchang_day = (panchang_response['day']).toString();
    }
    else {
      panchang_day = '';
    }

    if (panchang_tithi != null) {
      panchang_tithi = (panchang_response['tithi']).toString();
    }
    else {
      panchang_tithi = '';
    }

    if (panchang_yog != null) {
      panchang_yog = (panchang_response['yog']).toString();
    }
    else {
      panchang_yog = '';
    }

    if (panchang_nakshatra != null) {
      panchang_nakshatra = (panchang_response['nakshatra']).toString();
    }
    else {
      panchang_nakshatra = '';
    }

    if (panchang_karan != null) {
      panchang_karan = (panchang_response['karan']).toString();
    }
    else {
      panchang_karan = '';
    }

    if (panchang_sunrise != null) {
      panchang_sunrise = (panchang_response['sunrise']).toString();
    }
    else {
      panchang_sunrise = '';
    }

    if (panchang_sunset != null) {
      panchang_sunset = (panchang_response['sunset']).toString();
    }
    else {
      panchang_sunset = '';
    }

  }




  Future showGooglePlaceWidget() async {
    // Prediction p = await PlacesAutocomplete.show(
    var place = await PlacesAutocomplete.show(

        context: context,
        apiKey: "AIzaSyC54_RnAsutpoao87j9w-OmbawLMdKA1jo",
        mode: Mode.overlay,
        language: "en",
        radius: 10000000 == null ? null : 10000000

    );

    setState(() {
      birth_location = place.description.toString();
      locationController.text = birth_location;

      getlatlong(birth_location);
    });
  }

  void getlatlong(String birth_location) async {
    final query = birth_location;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    String coordinates = first.coordinates.toString();
    print('coordinates' + coordinates);
    List<String> result = coordinates.split(',');
    place_lat = result[0];
    List<String> result_lat = place_lat.split('{');
    //place_lat.replaceAll('{', '');
    print('place_lat' + result_lat[1]);
    place_lat = result_lat[1];
    place_long = result[1];
    List<String> result_long = place_long.split('}');
  //  place_long.replaceAll('}', '');
    print('place_long' + result_long[0]);
    place_long = result_long[0];
  }


}
