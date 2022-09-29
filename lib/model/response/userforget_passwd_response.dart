class UserForgetPasswordResponseModel
{
  bool status;
  String message;
  String email;


  UserForgetPasswordResponseModel();


  factory UserForgetPasswordResponseModel.fromJson(Map<String, dynamic> json){
    UserForgetPasswordResponseModel forgetPasswordResponseModel = new UserForgetPasswordResponseModel();
    forgetPasswordResponseModel.status = json["status"];
    forgetPasswordResponseModel.message = json["message"];
    forgetPasswordResponseModel.email = json["email"];


    return forgetPasswordResponseModel;
  }

}