
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:ascology_app/global/configFile.dart' as cf;


class AgentUploadImages extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentUploadImagesState createState() => _AgentUploadImagesState();
}

class _AgentUploadImagesState extends State<AgentUploadImages> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  SharedPreferences logindata;
  String session_agent_id,imgpath;

  var imgforupload;
  File _image;
  List<Asset> images = List<Asset>();

//  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getConnectivity();
   getsession_userid();
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

  void getsession_userid() async{
    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
    });
  }

  Future uploadmultipleimage() async {
    print('hi');
    var uri = Uri.parse('https://astroashram.com/app_api/submit_upload_image');
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.fields['agent_id'] = session_agent_id;
    //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));
  //  List<MultipartFile> newList = new List<MultipartFile>();
    for (int i = 0; i < images.length; i++) {
      File imageFile = File(images[i].toString());
      request.files.add(await http.MultipartFile.fromPath('image_up[]', imageFile.path));
      print(imageFile.path.toString());
     /* File imageFile = File(images[i].toString());
      var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile("imagefile", stream, length,
          filename: basename(imageFile.path));
      newList.add(multipartFile);*/
    }
 //   request.files.addAll(newList);
    http.StreamedResponse response = await request.send();
  //  var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  void _startUploading(List images) async {

      final Map<String, dynamic> response = await _uploadImage(images);

      // Check if any error occured
      if (response == null) {
        // pr.hide();


        print('hi');
        Fluttertoast.showToast(
            msg: "Images uploaded successfully...",
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


  Future<Map<String, dynamic>> _uploadImage(List images) async {


    try {
      var imageUploadRequest = http.MultipartRequest('POST', Uri.parse('https://astroashram.com/app_api/submit_upload_image'));
      print('imgpath'+imgpath);

     // List<MultipartFile> newList = new List<http.MultipartFile>();
      for (int i = 0; i < images.length; i++) {

        //  var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
        File imageFile = File(images[i].toString());

        imageUploadRequest.files.add(
            await http.MultipartFile.fromPath('image_up[]', imageFile.path));

    //    var pic = await http.MultipartFile.fromPath('image_up[]', imageFile.path);

      //  newList.add(pic);
        print(imageFile.path.toString());

      }

       /* imageUploadRequest.files.add(
            await http.MultipartFile.fromPath('image', imgpath));*/

      imageUploadRequest.fields['agent_id'] = session_agent_id;

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


/*
  Future uploadmultipleimagenew(List images) async {
   // var uri = Uri.parse("https://astroashram.com/app_api/submit_upload_image");

    try {

      var imageUploadRequest = http.MultipartRequest('POST', Uri.parse('https://astroashram.com/app_api/submit_upload_image'));

      http.MultipartRequest request = new http.MultipartRequest('POST', uri);
      request.fields['agent_id'] = session_agent_id;
      //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));
      List<MultipartFile> newList = new List<http.MultipartFile>();
      for (int i = 0; i < images.length; i++) {

      //  var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
        File imageFile = File(images[i].toString());
    //    File imageFile = File(path);
        */
/* var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();*//*


        var pic = await http.MultipartFile.fromPath('image_up[]', imageFile.path);
        */
/* request.files.add(
            await http.MultipartFile.fromPath('image_up[]', imageFile.path));*//*


       // request.files.add(pic);

          newList.add(pic);
        print(imageFile.path.toString());

      }

      print(newList);

    //  new
     */
/* for(int j = 0; j < newList.length; j++)
        {

        }*//*

      request.files.addAll(newList);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print("Image Uploaded");
      } else {
        print("Upload Failed");
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
    catch (e) {
      print(e);
      return null;
    }
  }
*/


  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar:  AppBar(
          title: Text('Upload Images', style: TextStyle(
              color: Colors.white,
              fontSize:  cf.Size.blockSizeHorizontal * 4.0,
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
        body: Column(
          children: <Widget>[
            //Center(child: Text('Error: $_error')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xffe22525)),
              child: Text("Choose images",style: TextStyle(
              color: Colors.white,
                  fontSize: cf.Size.blockSizeHorizontal * 3.0
              ),),
              onPressed: loadAssets,
            ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffe22525)),
              child: Text("Upload images",style: TextStyle(
                  color: Colors.white,
                  fontSize: cf.Size.blockSizeHorizontal * 3.0
              ),),
              onPressed: () {
               // uploadmultipleimagenew(images);

                _startUploading(images);
              }

            ),

            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }

}



