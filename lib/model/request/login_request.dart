class LoginRequestModel
{
  String mobile;
  String password;
  String token;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;

  LoginRequestModel();


/*
 LoginRequestModel({this.mobile, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number});

*/


  Map onlymobilepassword(){
    var map = new Map<dynamic, dynamic>();
    map["mobile"] = mobile;
    map["password"] = password;

    return map;
  }



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile.trim(),
      'password': password.trim(),
      'token': token.trim(),
      'device_name': device_name.trim(),
      'device_model': device_model.trim(),
      'apk_version': apk_version.trim(),
      'imei_number': imei_number.trim(),
    };

    return map;
  }


}