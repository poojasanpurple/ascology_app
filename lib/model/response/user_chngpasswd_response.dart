class UserChangePasswordResponseModel
{
  bool status;
  String message;


  UserChangePasswordResponseModel();


  factory UserChangePasswordResponseModel.fromJson(Map<String, dynamic> json){
    UserChangePasswordResponseModel changePasswordResponseModel = new UserChangePasswordResponseModel();
    changePasswordResponseModel.status = json["status"];
    changePasswordResponseModel.message = json["message"];


    return changePasswordResponseModel;
  }

}