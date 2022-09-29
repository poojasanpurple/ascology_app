
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/request/user_update_profile.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:ascology_app/utility/multiselectwidget.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ascology_app/global/configFile.dart' as cf;



class EditUerProfile extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  const EditUerProfile({Key key}) : super(key: key);


  @override
  _EditUerProfileState createState() => _EditUerProfileState();
}

class _EditUerProfileState extends State<EditUerProfile> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = false;
  var imgforupload;
  File _image;
  List<String> problemarealist = [];
  List<String> gotlist = [];
   List<String> selectedlist = [];

  List<int> indexlist = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];
  MultiSelectController myMultiSelectController = MultiSelectController();
  String session_user_id,session_imgpath;
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String apkversion = '1.1';
  List expertiselist = [];

  String reg_email, reg_name, reg_gender, reg_short_desc , reg_birthdate, reg_birthplace,
      reg_time,reg_img,birth_location,dropdownvalue_gender,formattedTime,pass_fromdate;
  var items =  ['Select','Male','Female'];
  String imgpath = '/path/to/file';
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController gendercontroller = TextEditingController();
  TextEditingController short_desc_controller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController birthplacecontroller = TextEditingController();
  TextEditingController birthtimeplacecontroller = TextEditingController();
  TextEditingController birthdatecontroller = TextEditingController();
  SharedPreferences logindata;
  String user_name,user_mobile,user_email,user_gender,user_desc,user_img,
      user_birthdate,user_birthplace,user_time;
  DateTime selectedDate = DateTime.now();
  String desc_all, new_desc_all = "";

  // var uuid= new Uuid();
  // var uuid= new Uuid();
  // String _sessionToken = new Uuid();

  final formKey = GlobalKey<FormState>();

  String _selectedGender ;
  var _selectedTime,finaltime;
  int sel;

  List problemData = [];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getConnectivity();

    getexpertise(context);

    fetch_user_details();

   /* myMultiSelectController.isSelecting = true;
    myMultiSelectController.disableEditingWhenNoneSelected = false;
    myMultiSelectController.set(problemarealist.length);*/


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

  /*@override
  void didChangeDependencies()
  {
    setState(() {
      selectedlist = gotlist;
    });

  }
*/


  void getexpertise(BuildContext context) async {
    setState(() {
      //isLoading = true;
    });
    var response = await http.post(AppUrl.get_expertise);
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      setState(() {
        expertiselist = items;
        //  isLoading = false;
        for(int i = 0; i < expertiselist.length;i++)
        {
          problemarealist.add(expertiselist[i]['name']);
        }

      });
    }else{
      expertiselist = [];
      // isLoading = false;
    }

   // print(expertiselist);

  }

  void _showMultiSelect() async {

    final List<String> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: problemarealist);
      },
    );



    // Update UI
    if (results != null) {
      setState(() {
        selectedlist = results;

       // selectedlist = results + gotlist;

       for(int i = 0; i< selectedlist.length;i++)
         {

          // if(selectedlist[i] == problemarealist[])
          // desc_all = desc_all + ',' + selectedlist[i];
           new_desc_all = new_desc_all + ',' +  selectedlist[i];
         }

     //   short_desc_controller.text = '${desc_all}';
       print(selectedlist);
       print(new_desc_all);
      });
    }
  }


  void fetch_user_details() async {
    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');
    session_imgpath = logindata.getString('user_imgpath');
    print('session_img '+session_imgpath.toString());

    var _loginApiClient = LoginApiClient();
    UserRequestModel model = UserRequestModel();
    model.user_id = session_user_id;
    print(model.toString());

    UserListingResponse userListingResponse = await _loginApiClient.getprofiledetails(model);

    print("!Q!Q!QQ!Q!Q!Q ${userListingResponse.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (userListingResponse.status = true) {
      print(userListingResponse.data);
      setState(() {
        isLoading = false;
      });

      user_name = userListingResponse.data[0].name.toString();
      user_mobile = userListingResponse.data[0].mobile.toString();
      user_email = userListingResponse.data[0].email.toString();
      user_gender = userListingResponse.data[0].gender.toString();
       desc_all = userListingResponse.data[0].short_description.toString();
      user_img = userListingResponse.data[0].image.toString();
      user_birthplace = userListingResponse.data[0].place_birth.toString();
      user_birthdate = userListingResponse.data[0].date_birth.toString();
      user_time = userListingResponse.data[0].time.toString();
      //  String a = AstrologerDetails.fromJson(userModel.data).agentname;
      print('desc_all'+desc_all);

      fullnameController.text = '${user_name}';
      emailController.text = '${user_email}';
      short_desc_controller.text = '${desc_all}';
      dobcontroller.text = '${user_birthdate}';
      birthtimeplacecontroller.text = '${user_time}';
      birthplacecontroller.text = '${user_birthplace}';
      birthdatecontroller.text = '${user_birthdate}';
      gendercontroller.text = '${user_gender}';

      _setImageView();


      // gotlist = desc_all.split(',');

      //print(problemarealist);
      print(gotlist);

   /*   setState(() {
        selectedlist = gotlist;
      });*/

     /* for(int i = 0 ; i < gotlist.length; i++) {
        myMultiSelectController.select(i);
      }*/

    /*  for(int i = 0; i < problemarealist.length; i++)
      {
        if(problemarealist[i] == gotlist[i])
        {

          selectedlist.add(i.toString());

        }
        else
        {
          // print(i);
        }
      }*/

    //  var sellist = problemarealist.toSet().intersection(gotlist.toSet()).toList();






/*

           if(user_gender == "female")
        {
          dropdownvalue_gender = user_gender;
        }
      else if(user_gender == "male")
        {
          dropdownvalue_gender = user_gender;
        }
*/



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

  //  _deviceDetails();

    cf.Size.init(context);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile', style: TextStyle(
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(40.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  /*  Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://astroashram.com/uploads/agent/${user_img}'),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {

                          openGallery();


                        },
                        child: new Text("Edit picture"),
                      ),
                    ),*/

                    SizedBox(height: 15.0,),
                    Text('Name*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),

                      // validator: validateEmail,
                      controller: fullnameController,
                      onSaved: (value) => reg_name = value,
                      decoration: buildInputDecoration("Enter Name", Icons.person),

                    ),
                    SizedBox(height: 20.0,),
                    Text('Email*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      autofocus: false,
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      //  validator: validateEmail,
                      onSaved: (value) => reg_email = value,
                      controller: emailController,
                      decoration: buildInputDecoration("Enter Email", Icons
                          .email),
                    ),
                    SizedBox(height: 20.0,),


                    Text("Add your problem area*",style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xffe22525)),
                      child:  Text('Select your problem areas',style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),),
                      onPressed: _showMultiSelect,

                    ),


                    Wrap(
                      children: selectedlist
                          .map((e) => Chip(
                        label: Text(e,style: TextStyle(
                            fontSize: cf.Size.blockSizeHorizontal * 2.5,
                            fontFamily: "Poppins"),),
                      ))
                          .toList(),


                    ),


                     /* ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: problemarealist.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                  child: MultiSelectItem(
                                   // key: ,
                                    isSelecting: myMultiSelectController.isSelecting,
                                    onSelected: () {
                                      setState(() {


                                        myMultiSelectController.toggle(index);
                                        print(myMultiSelectController.selectedIndexes.length);
                                        print(myMultiSelectController.selectedIndexes.toString());

                                        for(int i=0; i<myMultiSelectController.selectedIndexes.length; i++) {

                                          sel = myMultiSelectController.selectedIndexes.elementAt(i);
                                        }

                                        desc_all = desc_all + ',' + problemarealist[sel];

                                        print(desc_all);

                                        setState(() {
                                          short_desc_controller.text = desc_all;

                                        });


                                      });

                                      *//*Fluttertoast.showToast(
                                      msg: "Selected"+problemarealist[myMultiSelectController.selectedIndexes],
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );*//*
                                    },
                                    child: Card(
                                      color: myMultiSelectController.isSelected(index)

                                          ? const Color(0xffe22525)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(7)),
                                      ),
                                      child: Center(
                                        child: Text(problemarealist[index],
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600 ,fontFamily: 'Poppins',color: Colors.black54),textAlign: TextAlign.left),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          );
                        },
                      ),*/



                    Visibility(child:
                    TextFormField(
                      autofocus: false,
                      maxLines: 5,
                      readOnly: true,
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                    //  onSaved: (value) => reg_short_desc = value,
                      onSaved: (value) => desc_all = value,
                      decoration: buildInputDecoration(
                          "Enter short desc", Icons.description),
                      controller: short_desc_controller,
                    ),
                      visible: false,
                        ),

                    SizedBox(height: 20.0,),
                    Text('Date of Birth*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 5.0,),

                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      onSaved: (value) => reg_birthdate = value,
                      decoration: buildInputDecoration(
                          "Enter date of birth", Icons.calendar_today),
                      controller: birthdatecontroller,
                      onTap: ()
                      {
                        _selectDate(context);
                      },
                    ),


                    SizedBox(height: 20.0,),

                    Text('Time of birth*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      onSaved: (value) => _selectedTime = value,
                      decoration: buildInputDecoration(
                          "Enter time of birth", Icons.lock_clock),
                      controller: birthtimeplacecontroller,
                      onTap: ()
                      {
                        _showtime(context);
                      },
                    ),


                    SizedBox(height: 20.0,),

                    Text('Place of birth*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      autofocus: false,
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      onSaved: (value) => reg_birthplace = value,
                      onTap: ()
                      {

                      showGooglePlaceWidget();
                    //  _state = States.pickUpSate;
    /* Prediction p  = await PlacesAutocomplete.show(
                          context: context,
                         // radius: 10000000,
                          //types: [],
                         // strictbounds: false,
                          apiKey: "AIzaSyC54_RnAsutpoao87j9w-OmbawLMdKA1jo",
                          mode: Mode.overlay,
                          language: "fr",
                          components: [Component(Component.country, "fr")],
                        );*/
                        // displayPrediction(p);
                      },
                      validator: (val) =>
                      val.isEmpty ? 'Enter birth place' : null,
                      onChanged: (val) async {
                        setState(() => birth_location = val);

                      },
                      decoration: buildInputDecoration(
                          "Enter birth place", Icons.location_on),
                      controller: birthplacecontroller,
                    ),
                    SizedBox(height: 20.0,),

                   /* TextFormField(
                      readOnly: true,
                      autofocus: false,
                      onSaved: (value) => user_gender = value,
                      decoration: buildInputDecoration(
                          "Enter gender", Icons.person),
                      controller: gendercontroller,
                    ),
*/

                       Text('Select Gender*',style: TextStyle(
                           fontSize: cf.Size.blockSizeHorizontal * 3,
                           fontFamily: "Poppins"),),
                    SizedBox(height: 10.0,),

                    DropdownButton(
                      value: user_gender,

                      icon: Icon(Icons.keyboard_arrow_down),

                      items:items.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(
                                fontSize: cf.Size.blockSizeHorizontal * 3,
                                fontFamily: "Poppins"),)
                        );
                      }
                      ).toList(),
                      onChanged: (newValue){
                        setState(() {

                          user_gender = newValue.toString();
                        });
                      },

                    ),

                    SizedBox(height: 10.0),

                    Column(
                      children : <Widget> [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xffe22525)),
                          child: Text("Upload Profile image....",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3,
                              fontFamily: "Poppins"),),
                          onPressed: ()
                          {

                            // Navigator.pushReplacementNamed(context, '/login');
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);

                            openGallery();
                            print(_image.path);
                            setState(() {
                              imgpath = _image.path;
                            });


                            /*setState(() {
                              imgpath = _image.path;
                            });*/
                          },
                        ),

                        _setImageView(),


                       Visibility(child: Text(imgpath,style: TextStyle(
                           fontSize: cf.Size.blockSizeHorizontal * 3,
                           fontFamily: "Poppins"),), visible: false,),
                      ],


                    ),


                    GestureDetector(
                      onTap: () {

                        _startUploading();
                     //   update_user_profile(context);
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
                        child: Text("Update", style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: cf.Size.blockSizeHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white

                        ),),
                      ),
                    ),


                    SizedBox(height: 20.0,),

                  ],
                ),
              ),
            ),
          ),
        )
    );
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
      birthplacecontroller.text = birth_location;


    });

  }

  void openGallery() async {
    try {
      // var imgGallery = await ImagePicker.pickImage(source: ImageSource.gallery);
      imgforupload = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        //imgFile = File(imgforupload.path);
        _image = imgforupload;
         imgpath = _image.path;

      });

     /* setState(() {
        imgpath = _image.path;
      });*/
    }
    catch (e) {
      print("Image picker error " + e);
    }
   // Navigator.of(context).pop();
  }


  Widget _setImageView() {
    if (_image != null)
      {
        return Image.file(_image, width: 100, height: 100);
      }

    else if (user_img != null) {
      return Image.network(('https://astroashram.com/uploads/user/'+user_img), width: 100, height: 100);
    }

    else if (session_imgpath != null) {
        return Image.file((File(session_imgpath)), width: 100, height: 100);
      }
      else {
        return Text("Please select an image");
      }
    }


  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;

        reg_birthdate = ' ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
        pass_fromdate = DateFormat("yyyy-MM-dd").format(selectedDate);
        print('pass_fromdate'+pass_fromdate);
        birthdatecontroller.text = pass_fromdate;
      });
  }

  Future<void> _showtime(BuildContext context) async {
    final TimeOfDay result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {

        DateTime parsedTime = DateFormat.jm().parse(result.format(context).toString());
        //converting to DateTime so that we can further format on different pattern.
        print(parsedTime); //output 1970-01-01 22:53:00.000
         formattedTime = DateFormat('HH:mm').format(parsedTime);
        print(formattedTime); //output 14:59:00
       /* _selectedTime = result.format(context);

        finaltime = DateFormat('HH:mm').format(_selectedTime);*/
        birthtimeplacecontroller.text = formattedTime;
      });
    }
  }


  Future<Map<String, dynamic>> _uploadImage(File image) async {

    reg_name = fullnameController.text;
    reg_email = emailController.text;
   // reg_short_desc = short_desc_controller.text;
   desc_all = short_desc_controller.text;
    pass_fromdate = dobcontroller.text;
    reg_birthplace = birthplacecontroller.text;
   // reg_time = birthtimeplacecontroller.text;
    formattedTime = birthtimeplacecontroller.text;

    try {
    var imageUploadRequest = http.MultipartRequest('POST', Uri.parse('https://astroashram.com/app_api/update_user_profile'));
    print('imgpath'+imgpath);

    if (imgpath != null && imgpath.isNotEmpty && await image.exists() ) {
      imageUploadRequest.files.add(
          await http.MultipartFile.fromPath('image', imgpath));
    }

    else
      {
       /* imageUploadRequest.files.add(
            await http.MultipartFile.fromPath('image', ''));
*/
      }
    /*if(imgpath == '' )
      {
        imageUploadRequest.files.add(
            await http.MultipartFile.fromPath('image', ''));
      }
    else {
      imageUploadRequest.files.add(
          await http.MultipartFile.fromPath('image', imgpath));
    }*/

    imageUploadRequest.fields['name'] = reg_name;

    imageUploadRequest.fields['email'] = reg_email;

   /* if(user_gender=='Female')
      {
        user_gender = 'female';
      }
    else if(user_gender == 'Male')
      {
        user_gender = 'male';
      }*/
    imageUploadRequest.fields['gender'] = user_gender;
    imageUploadRequest.fields['user_id'] = session_user_id;
    imageUploadRequest.fields['date_birth'] = pass_fromdate;
    imageUploadRequest.fields['place_birth'] = reg_birthplace;
    imageUploadRequest.fields['time'] = formattedTime;
  //  imageUploadRequest.fields['short_description'] = desc_all;
    imageUploadRequest.fields['short_description'] = new_desc_all;

    // imageUploadRequest.files.add(file);
   // print('fields'+formattedTime);




     print('imageUploadRequest'+imageUploadRequest.fields['date_birth'].toString());
      print('imageUploadRequest'+imageUploadRequest.fields['place_birth']);
   //   print('imageUploadRequest'+imageUploadRequest.fields['time']);
      print('imageUploadRequest'+imageUploadRequest.fields['short_description']);
     // print('imageUploadRequest'+imageUploadRequest.fields['image']);

      http.StreamedResponse response = await imageUploadRequest.send();

      /* final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);*/
      if (response.statusCode != 200) {

        /* Fluttertoast.showToast(
            msg: "Mobile number already exists.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
        return null;
      }
      //8097874046
      final Map<String, dynamic> responseData = json.decode(response.toString());

      print(responseData.toString());
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }


  void _startUploading() async {

    if (
        reg_name != '' &&
        reg_email != '' &&
        reg_gender != '' &&
        pass_fromdate != '' && formattedTime != '' &&
            new_desc_all != '' &&
        reg_birthplace != '') {
      final Map<String, dynamic> response = await _uploadImage(_image);

      // Check if any error occured
      if (response == null) {
        // pr.hide();

        logindata = await SharedPreferences.getInstance();
        logindata.setString('user_imgpath',imgpath);

        print('hi');
        Fluttertoast.showToast(
            msg: "Profile updated successfully...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

        print('User details updated successfully');
      }
    }
    else
      {
        Fluttertoast.showToast(
            msg: "Please fill the mandatory fields...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

  }

  void update_user_profile(BuildContext context) async{

    reg_name = fullnameController.text;
    reg_email = emailController.text;
    reg_short_desc = short_desc_controller.text;
    reg_birthdate = dobcontroller.text;
    reg_birthplace = birthplacecontroller.text;
    reg_time = birthtimeplacecontroller.text;
    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");
           bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(reg_email);
              var _loginApiClient = LoginApiClient();
              UserUpdateProfileRequest registerRequestModel = new UserUpdateProfileRequest();

              registerRequestModel.name = reg_name;
              registerRequestModel.email = reg_email;
              registerRequestModel.gender = reg_gender;
              registerRequestModel.short_description = reg_short_desc;
              registerRequestModel.user_id = session_user_id;

              registerRequestModel.date_birth = pass_fromdate;
              registerRequestModel.place_birth = reg_birthplace;
              registerRequestModel.time = formattedTime;
              registerRequestModel.image = '';

              print(registerRequestModel);

              UserChangePasswordResponseModel registerResModel = await _loginApiClient.updateuser(registerRequestModel);

              if(registerResModel.status = true){

                Fluttertoast.showToast(
                    msg: "Profile updated successfully...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );

              }
              else{
                //loaderFun(context, false);
                //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Unable to create account.')));

                Fluttertoast.showToast(
                    msg: "Unable to update details...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);

              }



        }



  }
/*

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key key,  this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}
*/
