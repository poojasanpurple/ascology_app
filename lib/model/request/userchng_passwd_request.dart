class UserChangePasswordRequest
{
  String mobile;
  String new_password;
  String confirm_password;


  UserChangePasswordRequest();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile.trim(),
      'new_password': new_password.trim(),
      'confirm_password': confirm_password.trim(),
    };

    return map;
  }




}