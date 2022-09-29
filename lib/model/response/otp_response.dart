class OtpResponseModel
{
  bool status;
  String mobile;
  String message;



  OtpResponseModel();


  factory OtpResponseModel.fromJson(Map<String, dynamic> json){
    OtpResponseModel forgetPasswordResponseModel = new OtpResponseModel();
    forgetPasswordResponseModel.status = json["status"];
    forgetPasswordResponseModel.mobile = json["mobile"];
    forgetPasswordResponseModel.message = json["message"];

    return forgetPasswordResponseModel;
  }

}