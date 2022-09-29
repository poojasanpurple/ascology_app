import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HttpWebCall {
  Future<String> post(String apiName, String request) async {
    final response = await http.post(apiName, body: request);
    //final response = await http.post(apiName,  headers: {"Content-Type": "application/json"}, body: request);

    //  final response = await http.post("https://asccology.com/app_api/login", body: {"mobile":"9322809982","password":"444444","token":"","device_name":"","device_model":"","apk_version":"1.0","imei_number":""});
//    final response = await http.post(apiName, headers: {"Content-type": "multipart/form-data"} , body: {"mobile":"9322809982","password":"444444","token":"","device_name":"","device_model":"","apk_version":"1.0","imei_number":""});

    // final response = await http.post(apiName, body: request);
    print(response.statusCode.toString());
    print(response.body.toString());
    if (response.statusCode < 200 || response.statusCode > 400) {
     // print(response.statusCode.toString());
      return null;
    } else {
      return response.body;
    }
  }

  Future<String> get(String apiName) async {
    final response = await http.get(apiName,
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    print(response.statusCode.toString());
    if (response.statusCode < 200 || response.statusCode > 400) {
      print(response.statusCode.toString());
      return null;
    } else {
      return response.body;
    }
  }

  /*Future<String> uploadDocuments(String apiName, List<AttachmentReqModel> attachmentReq) async{
    var postUri = Uri.parse(apiName);
    var request = http.MultipartRequest("POST", postUri);
    for(var attachment in attachmentReq) {
      // open a bytestream
      request.fields["attachmentRequestModel"] = json.encode(attachment.topMap());
      switch(attachment.DocumentType){
        case 1:
        case 2:
          var lengthFront = await attachment.front.length();
          var multipartFileFront = new http.MultipartFile('file', getBytesOfFile(attachment.front), lengthFront,
              filename: basename(attachment.front.path), contentType: new MediaType("image", "*"));
          request.files.add(multipartFileFront);

          var lengthBack = await attachment.back.length();
          var multipartFileBack = new http.MultipartFile('file', getBytesOfFile(attachment.back), lengthBack,
              filename: basename(attachment.back.path), contentType: new MediaType("image", "*"));
          request.files.add(multipartFileBack);

          break;
        case 3:
          break;

      }

    }

    final response = await request.send();

    if(response.statusCode == 200){
      return "200";
    }
    else{
      return "400";
    }

  }

  Future<String> uploadProfileSingle(String apiName, AttachmentReqModelForDP attachment) async{
    var postUri = Uri.parse("$apiName/${attachment.AddedById}/${attachment.DocumentType}");
    var request = http.MultipartRequest("POST", postUri);

    var lengthFront = await attachment.full.length();
    var multipartFileFront = new http.MultipartFile('file', getBytesOfFile(attachment.full), lengthFront,
        filename: basename(attachment.full.path), contentType: new MediaType("image", "*"));
    request.files.add(multipartFileFront);

    final response = await request.send();

    if(response.statusCode == 200){
      return "200";
    }
    else{
      return "400";
    }

  }

  http.ByteStream getBytesOfFile(File file){
    return http.ByteStream(DelegatingStream.typed(file.openRead()));
  }*/

}
