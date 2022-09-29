class UserVerifyOtpRequest
{
  String mobile;
  String otp;


  UserVerifyOtpRequest();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile.trim(),
      'otp': otp.trim(),
    };

    return map;
  }


  Map toMap(){
    var map = new Map<dynamic, dynamic>();
    map["mobile"] = mobile;
    map["otp"] = otp;

    return map;
  }

}