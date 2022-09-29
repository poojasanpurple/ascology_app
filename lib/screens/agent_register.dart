
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ascology_app/utility/MultiSelectDefaultItem.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_register_request.dart';
import 'package:ascology_app/model/response/agent_register_response.dart';
import 'package:ascology_app/model/response/category_model.dart';
import 'package:ascology_app/screens/agent_forgtpasswd.dart';
import 'package:ascology_app/screens/agent_login.dart';
import 'package:ascology_app/screens/user_verify_otp.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:http/http.dart' as http;
import 'package:ascology_app/global/configFile.dart' as cf;



class Agent_Register extends StatefulWidget {
  //const Agent_Register({Key? key}) : super(key: key);
  Agent_Register({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _Agent_Register_State createState() => _Agent_Register_State();
}

class _Agent_Register_State extends State<Agent_Register> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  var imgforupload;

  String agent_name, agent_mobile, agent_timings, agent_passsword, agent_desc,category_selection,language_selection,
  agent_experience,agent_image,agent_bigimg;
  List<String> selectedlist = [];

  String new_desc_all = "";

  TextEditingController agentnameController = TextEditingController();
  TextEditingController agentmobileController = TextEditingController();
  TextEditingController agenttimingsController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fulldescController = TextEditingController();
  TextEditingController expController = TextEditingController();

  String dropdownvalue_category = 'Select';
  String dropdownvalue_language = 'Select';

  final formKey = GlobalKey<FormState>();
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String apkversion = '1.1';
  List expertiselist = [];

  List<String> problemarealist = [];

//  List category_list = List();
 // List language_list = List();
  List<CategoryModel> category_list;
  List<Map<String, dynamic>> language_list;
  String imgpath = '/path/to/file';
  String cat_id,lang_id;
  var items =  ['Select','Astrology','Numerology','Mental Wellness','Tarot Reading'];
  var languages =  ['Select','Assamese','Bengali','English','Gujarati','Hindi','Kannada','Maithili','Malayalam','Marathi','Odia','Punjabi','Sanskrit','Tamil','Telugu','Urdu'];
  File imgFile;
  final imgPicker = ImagePicker();
  File _image;
  MultiSelectController myMultiSelectController = MultiSelectController();
  int sel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  this.getcategory(context);
   // this.getlanguage(context);

    getConnectivity();

    //problem areas
    this.getexpertise(context);

    myMultiSelectController.disableEditingWhenNoneSelected = true;
    myMultiSelectController.set(problemarealist.length);
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

  void _showMultiSelect() async {

    final List<String> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDefaultItem(items: problemarealist);
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


  //String _userName, _password;


  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Agent Registration', style: TextStyle(
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
                  SizedBox(height: 15.0,),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                    // validator: validateEmail,
                    controller: agentnameController,
                    onSaved: (value) => agent_name = value,
                    decoration: buildInputDecoration("Enter Agent Name", Icons
                        .person),
                  ),
                  SizedBox(height: 20.0,),

                  TextFormField(
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                    autofocus: false,
                    obscureText: true ,
                      controller: passwordController,
                      validator: (value)=> value.isEmpty?"Please enter password":null,
                     onSaved: (value)=> agent_passsword = value,
                       decoration: buildInputDecoration('Enter Password',Icons.lock),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                    autofocus: false,
                    // validator: validateEmail,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: agentmobileController,
                    onSaved: (value)=> agent_mobile = value,
                        decoration: buildInputDecoration('Enter mobile number',Icons.phone),
                  ),
                  SizedBox(height: 20.0,),

                  TextFormField(
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                    autofocus: false,
                    // validator: validateEmail,
                    controller: agenttimingsController,
                    onSaved: (value)=> agent_timings = value,
                         decoration: buildInputDecoration('Enter timings',Icons.timer),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Experience (in years) *", style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3,
                      fontFamily: "Poppins"),),
                  SizedBox(height: 5.0,),

                  NumberInputWithIncrementDecrement(
                controller: expController,
                    min: 0,
                    onIncrement: (num newlyIncrementedValue) {
                      print('Newly incremented value is $newlyIncrementedValue');
                    },
                    onDecrement: (num newlyDecrementedValue) {
                      print('Newly decremented value is $newlyDecrementedValue');
                    },

                  ),
                  SizedBox(height: 20.0,),
                  SizedBox(height: 5.0,),
                  Container(
                   // child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          Text("Select Category *", style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 2.8,
                              fontFamily: "Poppins"),),
                          SizedBox(width : 25.0,),

                          DropdownButton(
                            value: dropdownvalue_category,

                            icon: Icon(Icons.keyboard_arrow_down),

                            items:items.map((String items) {
                              return DropdownMenuItem(
                                  value: items,
                                  child: Text(items, style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 2.7,
                                      fontFamily: "Poppins"),)
                              );
                            }
                            ).toList(),
                            onChanged: (newValue){
                              setState(() {

                                dropdownvalue_category = newValue.toString();
                              });
                            },

                          ),
                        ],
                      ),
                   // ),
                  ),

                  SizedBox(height: 15.0,),
                  Container(
                   // child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Select language *", style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 2.8,
                              fontFamily: "Poppins"),),

                          SizedBox(width : 30.0,),
                          DropdownButton(
                            value: dropdownvalue_language,
                            icon: Icon(Icons.keyboard_arrow_down),

                            items:languages.map((String items) {
                              return DropdownMenuItem(
                                  value: items,
                                  child: Text(items, style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 2.7,
                                      fontFamily: "Poppins"),)
                              );
                            }
                            ).toList(),
                            onChanged: (newValue){
                              setState(() {
                                dropdownvalue_language = newValue.toString();
                              });
                            },

                          ),
                        ],
                      ),
                  //  ),
                  ),
                 /* new DropdownButton(
                    items: category_list?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['title'],
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                        ),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (String newVal) {
                      setState(() {
                        category_selection = newVal;
                        print(category_selection.toString());

                      });
                    },
                    value: category_selection,
                  ),*/

                  SizedBox(height: 20.0,),


                 /* new DropdownButton(
                    items: category_list.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['title'],
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (String newVal) {
                      setState(() {
                        language_selection = newVal;
                        print(language_selection.toString());

                      });
                    },
                    value: language_selection,
                  ),
*/
                  SizedBox(height: 20.0,),


                  TextFormField(
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                    autofocus: false,
                    maxLines: 5,
                    decoration: buildInputDecoration('Full Description',Icons.info_outline),

                    // validator: validateEmail,
                    //onSaved: (value)=> _userName = value,
                    //     decoration: buildInputDecoration('Enter Email',Icons.email),
                  ),
                  SizedBox(height: 20.0,),


                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xffe22525)),
                            child: Text("Select Profile image....",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3,),),
                            onPressed: ()
                            {

                              // Navigator.pushReplacementNamed(context, '/login');
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);

                              showOptionsDialog(context);
                              print(_image.path);

                             setState(() {
                                imgpath = _image.path;
                              });
                            },
                          ),
                          _setImageView(),
                          Visibility(child: Text(imgpath, style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 3,
                              fontFamily: "Poppins"),), visible: false,),
                        ],


                  ),

                  SizedBox(height: 20.0,),


                  Text("Add your expertise areas",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3,)),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xffe22525)),
                    child:  Text('Select your expertise areas', style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),) ,
                    onPressed: _showMultiSelect,

                  ),


                  Wrap(
                    children: selectedlist
                        .map((e) => Chip(
                      label: Text(e),
                    ))
                        .toList(),


                  ),




                  SizedBox(height: 20.0,),

                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),

                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Already have account? ',
                          style: TextStyle(
                            fontSize: cf.Size.blockSizeHorizontal * 4,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 4,
                              color: Colors.red,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AgentLogin()),
                                );
                              }),
                      ]),
                    ),

                  ),

                  SizedBox(height: 20.0,),


                  Center(child:
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(220, 50),
                        maximumSize: const Size(220, 50),
                        primary: const Color(0xffe22525)),
                    child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w400, fontSize: cf.Size.blockSizeHorizontal * 4,),),
                    onPressed: ()
                    {
                      // Navigator.pushReplacementNamed(context, '/login');
                   //   Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);

                      agent_name = agentnameController.text;
                      agent_mobile = agentmobileController.text;
                      agent_timings = agenttimingsController.text;
                      agent_passsword = passwordController.text;
                     // agent_desc = fulldescController.text;
                      agent_experience = expController.text;

                      _startUploading();
                   //agent_register(context);
                   //   uploadimg();

                    },
                  ),
                  )


                  /*auth.loggedInStatus == Status.Authenticating
                      ?loading
                      : longButtons('Login',doLogin),
                  SizedBox(height: 8.0,),
                  forgotLabel*/

                ],
              ),
            ),
          ),


        ),
      ),
    );
  }

  void _startUploading() async {

    if (agent_name != '' &&
        agent_mobile != '' &&
        agent_passsword != '' &&
        agent_experience != '' &&
        agent_timings != '' &&
    category_selection !='' &&
    language_selection != '' &&
        new_desc_all != '' &&
        (imgpath != null && imgpath.isNotEmpty)) {

      final Map<String, dynamic> response = await _uploadImage(_image);

      // Check if any error occured
      if (response == null) {
       // pr.hide();

        print('hi');
        Fluttertoast.showToast(
            msg: "OTP sent to your mobile...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.push(context,
            MaterialPageRoute(
              builder: (context) {
                return UserVerifyOtp(
                    mobile: agent_mobile, usertype: "Agent");
              },
            ));
        print('User details updated successfully');
      }
    } else {

      print('Error');
     Fluttertoast.showToast(
          msg: "Please enter all mandatory details..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


  // Future<String> uploadImage(filename, url) async {
 uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }

/*
  Future<Map<String, dynamic>> _uploadImage(File image) async {

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(AppUrl.agent_registration));

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(
        'image', image.path);
       // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension

//    imageUploadRequest.fields['ext'] = mimeTypeData[1];

    imageUploadRequest.files.add(file);
    */
/*imageUploadRequest.fields['agentname'] = agent_name;
    imageUploadRequest.fields['mobile'] = agent_mobile;
    imageUploadRequest.fields['timing'] = agent_timings;
    imageUploadRequest.fields['experience'] = agent_experience;
    imageUploadRequest.fields['category'] = category_selection;
    imageUploadRequest.fields['language'] = language_selection;
    imageUploadRequest.fields['password'] = agent_passsword;
    imageUploadRequest.fields['device_name'] = '';
    imageUploadRequest.fields['device_model'] = '';
    imageUploadRequest.fields['apk_version'] = apkversion;
    imageUploadRequest.fields['imei_number'] = '';
*//*

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
     // _resetState();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }
*/

 /*  void uploadimg() async
  {
    final Map<String, dynamic> response = await _uploadImage(_image);

    // Check if any error occured
    if (response == null) {
     // pr.hide();
      print('User details updated successfully');
    }
  }
*/
  Uri apiUrl = Uri.parse(
      'https://astroashram.com/app_api/agent_registration');

  Future<Map<String, dynamic>> _uploadImage(File image) async {


    var imageUploadRequest = http.MultipartRequest('POST', Uri.parse('https://astroashram.com/app_api/agent_registration'));
    print(imageUploadRequest);

    // Attach the file in the request
   /* final file = await http.MultipartFile.fromPath(
        'image', image.path,); */
    /*final file = await http.MultipartFile.fromPath(
        'image', imgpath);*/

    if (imgpath != null && imgpath.isNotEmpty && await image.exists() ) {
      imageUploadRequest.files.add(await http.MultipartFile.fromPath('image', imgpath));

    }
    else
      {

      }


    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension

//    imageUploadRequest.fields['ext'] = mimeTypeData[1];


    imageUploadRequest.fields['agentname'] = agent_name;

    imageUploadRequest.fields['mobile'] = agent_mobile;
    imageUploadRequest.fields['timing'] = agent_timings;
    imageUploadRequest.fields['experience'] = agent_experience;

    if(dropdownvalue_category == 'Psychology') {
      cat_id = '1';
    }
    else if(dropdownvalue_category == 'Numerology')
      {
        cat_id = '2';
      }
    else if(dropdownvalue_category == 'Tarot Card')
      {
        cat_id = '3';
      }
    else if(dropdownvalue_category == 'Astrology')
      {
        cat_id = '4';
      }

    imageUploadRequest.fields['category'] = cat_id;
    print(dropdownvalue_category);

    if(dropdownvalue_language == 'English') {
      lang_id = '1';
    }
    else if(dropdownvalue_language == 'Hindi')
    {
      lang_id = '2';
    }
    else if(dropdownvalue_language == 'Gujarati')
    {
      lang_id = '3';
    }
    else if(dropdownvalue_language == 'Bengali')
    {
      lang_id = '4';
    }
    else if(dropdownvalue_language == 'Marathi')
    {
      lang_id = '5';
    } else if(dropdownvalue_language == 'Telugu')
    {
      lang_id = '6';
    } else if(dropdownvalue_language == 'Tamil')
    {
      lang_id = '7';
    } else if(dropdownvalue_language == 'Urdu')
    {
      lang_id = '8';
    } else if(dropdownvalue_language == 'Kannada')
    {
      lang_id = '9';
    } else if(dropdownvalue_language == 'Odia')
    {
      lang_id = '10';
    } else if(dropdownvalue_language == 'Malayalam')
    {
      lang_id  = '11';
    } else if(dropdownvalue_language == 'Punjabi')
    {
      lang_id = '12';
    } else if(dropdownvalue_language == 'Assamese')
    {
      lang_id = '13';
    } else if(dropdownvalue_language == 'Maithili')
    {
      lang_id = '14';
    } else if(dropdownvalue_language == 'Sanskrit')
    {
      lang_id = '15';
    }


    imageUploadRequest.fields['language'] = lang_id;
    imageUploadRequest.fields['password'] = agent_passsword;
    imageUploadRequest.fields['description'] = new_desc_all;
    imageUploadRequest.fields['device_name'] = '';
    imageUploadRequest.fields['device_model'] = '';
    imageUploadRequest.fields['apk_version'] = '1.1';
    imageUploadRequest.fields['imei_number'] = '';
   // imageUploadRequest.files.add(file);
    print(imageUploadRequest.fields);

    try {

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

  //agent_register(BuildContext context) async {
   void agent_register(BuildContext context) async {

    agent_name = agentnameController.text;
    agent_mobile = agentmobileController.text;
    agent_timings = agenttimingsController.text;
    agent_experience = expController.text;
    //agent_image = '';
    agent_bigimg = '';
    agent_passsword = passwordController.text;


    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");
    if (agent_name != null && agent_name != "") {
            if (agent_passsword != null && agent_passsword != '') {
              var _loginApiClient = LoginApiClient();
              AgentRegisterRequestModel agentRegisterRequestModel = new AgentRegisterRequestModel();

              var request = http.MultipartRequest("POST", Uri.parse(AppUrl.agent_registration));
              //add text fields
              //create multipart using filepath, string or bytes


            //  request.headers[''] = '';
              request.fields['agentname'] = agent_name;
              request.fields['mobile'] = agent_mobile;
              request.fields['timing'] = agent_timings;
              request.fields['experience'] = agent_experience;
              request.fields['category'] = category_selection;
              request.fields['language'] = language_selection;
              request.fields['password'] = agent_passsword;
              request.fields['device_name'] = '';
              request.fields['device_model'] = '';
              request.fields['apk_version'] = apkversion;
              request.fields['imei_number'] = '';
              request.files.add(await http.MultipartFile.fromPath('image', _image.path));


              var response = await request.send();
              var responsedone = await http.Response.fromStream(response);
              final responseData = json.decode(responsedone.body);

              if(response.statusCode == 200) {

                print(responseData);

                Fluttertoast.showToast(
                    msg: "OTP sent to your mobile...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );

                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UserVerifyOtp(
                            mobile: agent_mobile, usertype: "Agent");
                      },
                    ));
              }
            /* agentRegisterRequestModel.agentname = agent_name;
              agentRegisterRequestModel.mobile = agent_mobile;
              agentRegisterRequestModel.timing = agent_timings;
              agentRegisterRequestModel.experience = agent_experience;
              agentRegisterRequestModel.category = category_selection;
              agentRegisterRequestModel.language = language_selection;


              agentRegisterRequestModel.password = agent_passsword;
              agentRegisterRequestModel.device_name = '';
              agentRegisterRequestModel.device_model = '';
              agentRegisterRequestModel.apk_version = apkversion;
              agentRegisterRequestModel.imei_number = '';
             // agentRegisterRequestModel.image = uploadimg();
              agentRegisterRequestModel.image = (await _uploadImage(_image)) as String;
                  //uploadimg();
            //  print(agentRegisterRequestModel.image);
              AgentRegisterResponseModel registerResponseModel = await _loginApiClient.agentregister(agentRegisterRequestModel);*/

              
           //   var response = await request.send();

              else {
                //loaderFun(context, false);
                //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Unable to create account.')));

                Flushbar(
                  // title: 'Invalid form',
                  message: 'Unable to create account',
                  duration: Duration(seconds: 3),
                ).show(context);

                // Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);


              }
            }
            else {
              Flushbar(
                // title: 'Invalid form',
                message: 'Please enter your password',
                duration: Duration(seconds: 3),
              ).show(context);

              /* loaderFun(context, false);
              _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter your password.')));*/
            }

    }
    else {
      Flushbar(
        // title: 'Invalid form',
        message: 'Please enter your full name',
        duration: Duration(seconds: 5),
      ).show(context);
      /*loaderFun(context, false);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter your full name')));*/
    }
  }

  Future<void> showOptionsDialog(BuildContext context) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Options"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Capture Image From Camera"),
                    onTap: () {
                      openCamera();

                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text("Take Image From Gallery"),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });

  }

  void openCamera() async {
    try {

      //var imgCamera = await ImagePicker.pickImage(source: ImageSource.camera);
       imgforupload = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
      //  imgFile = File(imgforupload.path);
        _image = imgforupload;

       // imgpath = _image.path;

      });
    }
    catch (e) {
      print("Image picker error " + e);
    }
    Navigator.of(context).pop();
  }

  void openGallery() async {
    try {
   // var imgGallery = await ImagePicker.pickImage(source: ImageSource.gallery);
      imgforupload = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      //imgFile = File(imgforupload.path);
      _image = imgforupload;
     // imgpath = _image.path;
    });
    }
    catch (e) {
      print("Image picker error " + e);
    }
    Navigator.of(context).pop();
  }


  Widget _setImageView() {
    if (_image != null)
    {
      return Image.file(_image, width: 100, height: 100);
    }

    else {
      return Text("Please select an image");
    }
  }


  Widget displayImage(){
    if(imgFile == null){
      return Text("No Image Selected!");
    } else{
      return Image.file(imgFile, width: 350, height: 350);
    }
  }

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

  }

}